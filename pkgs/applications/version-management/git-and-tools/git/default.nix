{ fetchurl, stdenv, curl, openssl, zlib, expat, perl, python, gettext, cpio, gnugrep
, asciidoc, texinfo, xmlto, docbook2x, docbook_xsl, docbook_xml_dtd_45
, libxslt, tcl, tk, makeWrapper, hardlink
, svnSupport, subversionClient, perlLibs, smtpPerlLibs
, guiSupport
, withManual ? true
, pythonSupport ? true
, sendEmailSupport
}:

let

  version = "1.8.2";

  svn = subversionClient.override { perlBindings = true; };

in

stdenv.mkDerivation {
  name = "git-${version}";

  src = fetchurl {
    url = "http://git-core.googlecode.com/files/git-${version}.tar.gz";
    sha256 = "1rhkya4kfs7iayasgj3bk8zg1pfk3h7wqhfy9d6aaqjgzb75pwy2";
  };

  patches = [ ./docbook2texi.patch ];

  buildInputs = [curl openssl zlib expat gettext cpio makeWrapper]
    ++ stdenv.lib.optionals withManual [ asciidoc texinfo xmlto docbook2x
         docbook_xsl docbook_xml_dtd_45 libxslt ]
    ++ stdenv.lib.optionals guiSupport [tcl tk];

  # required to support pthread_cancel()
  NIX_LDFLAGS = stdenv.lib.optionalString (!stdenv.isDarwin) "-lgcc_s";

  makeFlags = "prefix=\${out} PERL_PATH=${perl}/bin/perl SHELL_PATH=${stdenv.shell} "
      + (if pythonSupport then "PYTHON_PATH=${python}/bin/python" else "NO_PYTHON=1");

  # FIXME: "make check" requires Sparse; the Makefile must be tweaked
  # so that `SPARSE_FLAGS' corresponds to the current architecture...
  #doCheck = true;

  postInstall =
    ''
      notSupported() {
        echo -e "#\!/bin/sh\necho '`basename $1` not supported, $2'\nexit 1" > "$1"
        chmod +x $1
      }

      # Install contrib stuff.
      mkdir -p $out/share/git
      mv contrib $out/share/git/
      mkdir -p $out/share/emacs/site-lisp
      ln -s "$out/share/git/contrib/emacs/"*.el $out/share/emacs/site-lisp/
      mkdir -p $out/etc/bash_completion.d
      ln -s $out/share/git/contrib/completion/git-completion.bash $out/etc/bash_completion.d/

      # grep is a runtime dependence, need to patch so that it's found
      substituteInPlace $out/libexec/git-core/git-sh-setup \
          --replace ' grep' ' ${gnugrep}/bin/grep' \
          --replace ' egrep' ' ${gnugrep}/bin/egrep'

      # Fix references to the perl binary. Note that the tab character
      # in the patterns is important.
      sed -i -e 's|	perl -ne|	${perl}/bin/perl -ne|g' \
             -e 's|	perl -e|	${perl}/bin/perl -e|g' \
             $out/libexec/git-core/{git-am,git-submodule}
    ''

   + (if svnSupport then

      ''# wrap git-svn
        gitperllib=$out/lib/perl5/site_perl
        for i in ${builtins.toString perlLibs} ${svn}; do
          gitperllib=$gitperllib:$i/lib/perl5/site_perl
        done
        wrapProgram $out/libexec/git-core/git-svn     \
                     --set GITPERLLIB "$gitperllib"   \
                     --prefix PATH : "${svn}/bin" ''
       else '' # replace git-svn by notification script
        notSupported $out/libexec/git-core/git-svn "reinstall with config git = { svnSupport = true } set"
       '')

   + (if sendEmailSupport then
      ''# wrap git-send-email
        gitperllib=$out/lib/perl5/site_perl
        for i in ${builtins.toString smtpPerlLibs}; do
          gitperllib=$gitperllib:$i/lib/perl5/site_perl
        done
        wrapProgram $out/libexec/git-core/git-send-email \
                     --set GITPERLLIB "$gitperllib" ''
       else '' # replace git-send-email by notification script
        notSupported $out/libexec/git-core/git-send-email "reinstall with config git = { sendEmailSupport = true } set"
       '')

   + stdenv.lib.optionalString withManual ''# Install man pages and Info manual
       make -j $NIX_BUILD_CORES -l $NIX_BUILD_CORES PERL_PATH="${perl}/bin/perl" cmd-list.made install install-info \
         -C Documentation ''

   + (if guiSupport then ''
       # Wrap Tcl/Tk programs
       for prog in bin/gitk libexec/git-core/{git-gui,git-citool,git-gui--askpass}; do
         sed -i -e "s|exec 'wish'|exec '${tk}/bin/wish'|g" \
                -e "s|exec wish|exec '${tk}/bin/wish'|g" \
                "$out/$prog"
       done
     '' else ''
       # Don't wrap Tcl/Tk, replace them by notification scripts
       for prog in bin/gitk libexec/git-core/git-gui; do
         notSupported "$out/$prog" \
                      "reinstall with config git = { guiSupport = true; } set"
       done
     '');

  # Git installs many copies of the same binary using hardlinks, but unfortunately
  # our patchELF phase re-writes those files and destroys the hardlinks in the
  # process. This utility re-generates them afterwards.
  postFixup = "${hardlink}/bin/hardlink $out";

  enableParallelBuilding = true;

  meta = {
    homepage = "http://git-scm.com/";
    description = "Git, a popular distributed version control system";
    license = stdenv.lib.licenses.gpl2Plus;

    longDescription = ''
      Git, a popular distributed version control system designed to
      handle very large projects with speed and efficiency.
    '';

    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.ludo stdenv.lib.maintainers.simons ];
  };
}
