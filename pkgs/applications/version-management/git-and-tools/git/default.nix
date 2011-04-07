{ fetchurl, stdenv, curl, openssl, zlib, expat, perl, python, gettext, cpio, gnugrep
, asciidoc, texinfo, xmlto, docbook2x, docbook_xsl, docbook_xml_dtd_45
, libxslt, tcl, tk, makeWrapper
, svnSupport, subversion, perlLibs, smtpPerlLibs
, guiSupport
, pythonSupport ? true
, sendEmailSupport
}:

let
  svn = subversion.override { perlBindings = true; };
in

stdenv.mkDerivation rec {
  name = "git-1.7.4.4";

  src = fetchurl {
    url = "mirror://kernel/software/scm/git/${name}.tar.bz2";
    sha256 = "5c3e738b01a4021ade56abebfdcce8825d2a50868e5c7befb65102f497387aa0";
  };

  patches = [ ./docbook2texi.patch ];

  buildInputs = [curl openssl zlib expat gettext cpio makeWrapper]
    ++ # documentation tools
       [ asciidoc texinfo xmlto docbook2x
         docbook_xsl docbook_xml_dtd_45 libxslt ]
    ++ stdenv.lib.optionals guiSupport [tcl tk];

  makeFlags = "prefix=\${out} PERL_PATH=${perl}/bin/perl SHELL_PATH=${stdenv.shell} "
      + (if pythonSupport then "PYTHON_PATH=${python}/bin/python" else "NO_PYTHON=1");

  # FIXME: "make check" requires Sparse; the Makefile must be tweaked
  # so that `SPARSE_FLAGS' corresponds to the current architecture...
  #doCheck = true;

  postInstall =
    ''
      notSupported(){
        echo -e "#\!/bin/sh\necho '`basename $1` not supported, $2'\nexit 1" > "$1"
        chmod +x $1
      }

      # Install Emacs mode.
      echo "installing Emacs mode..."
      ensureDir $out/share/emacs/site-lisp
      cp -p contrib/emacs/*.el $out/share/emacs/site-lisp

      # grep is a runtime dependence, need to patch so that it's found
      substituteInPlace $out/libexec/git-core/git-sh-setup \
          --replace ' grep' ' ${gnugrep}/bin/grep' \
          --replace ' egrep' ' ${gnugrep}/bin/egrep'
    '' # */

   + (if svnSupport then

      ''# wrap git-svn
        gitperllib=$out/lib/perl5/site_perl
        for i in ${builtins.toString perlLibs} ${svn}; do
          gitperllib=$gitperllib:$i/lib/perl5/site_perl
        done
        wrapProgram "$out/libexec/git-core/git-svn"     \
                     --set GITPERLLIB "$gitperllib"     \
                     --prefix PATH : "${svn}/bin" ''
       else '' # replace git-svn by notification script
        notSupported $out/bin/git-svn "reinstall with config git = { svnSupport = true } set"
       '')

   + (if sendEmailSupport then
      ''# wrap git-send-email
        gitperllib=$out/lib/perl5/site_perl
        for i in ${builtins.toString smtpPerlLibs}; do
          gitperllib=$gitperllib:$i/lib/perl5/site_perl
        done
        wrapProgram "$out/libexec/git-core/git-send-email"     \
                     --set GITPERLLIB "$gitperllib" ''
       else '' # replace git-send-email by notification script
        notSupported $out/bin/git-send-email "reinstall with config git = { sendEmailSupport = true } set"
       '')

   + ''# Install man pages and Info manual
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
     '')

   + ''# install bash completion script
      d="$out/etc/bash_completion.d"
      ensureDir $d; cp contrib/completion/git-completion.bash "$d"
     ''
   # Don't know why hardlinks aren't created. git installs the same executable
   # multiple times into $out so replace duplicates by symlinks because I
   # haven't tested whether the nix distribution system can handle hardlinks.
   # This reduces the size of $out from 115MB down to 13MB on x86_64-linux!
   + ''
      declare -A seen
      shopt -s globstar
      for f in "$out/"**; do
        test -f "$f" || continue
        sum=$(md5sum "$f");
        sum=''\${sum/ */}
        if [ -z "''\${seen["$sum"]}" ]; then
          seen["$sum"]="$f"
        else
          rm "$f"; ln -v -s "''\${seen["$sum"]}" "$f"
        fi
      done
     '';

  enableParallelBuilding = true;

  meta = {
    license = "GPLv2";
    homepage = http://git-scm.com/;
    description = "Git, a popular distributed version control system";

    longDescription = ''
      Git, a popular distributed version control system designed to
      handle very large projects with speed and efficiency.
    '';

    maintainers =
      [ # Add your name here!
        stdenv.lib.maintainers.ludo
        stdenv.lib.maintainers.simons
      ];

    platforms = stdenv.lib.platforms.all;
  };
}
