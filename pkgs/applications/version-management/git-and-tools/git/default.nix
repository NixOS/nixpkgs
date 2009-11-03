{ fetchurl, stdenv, curl, openssl, zlib, expat, perl, gettext, cpio
, asciidoc, texinfo, xmlto, docbook2x, docbook_xsl, docbook_xml_dtd_45
, libxslt, tcl, tk, makeWrapper
, svnSupport, subversion, perlLibs
, guiSupport
}:

# `git-svn' support requires Subversion and various Perl libraries.
assert svnSupport -> (subversion != null && perlLibs != [] && subversion.perlBindings);

stdenv.mkDerivation rec {
  name = "git-1.6.5.2";

  src = fetchurl {
    url = "mirror://kernel/software/scm/git/${name}.tar.bz2";
    sha256 = "a7050b45a4c5a2b40db83dc67dc3ff4b422ef1864df72316b3221ead2eefb5c1";
  };

  patches = [ ./docbook2texi.patch ];

  buildInputs = [curl openssl zlib expat gettext cpio makeWrapper]
    ++ # documentation tools
       [ asciidoc texinfo xmlto docbook2x
         docbook_xsl docbook_xml_dtd_45 libxslt ]
    ++ stdenv.lib.optionals guiSupport [tcl tk];

  makeFlags = "prefix=\${out} PERL_PATH=${perl}/bin/perl SHELL_PATH=${stdenv.shell}";

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
    '' # */

   + (if svnSupport then

      ''# wrap git-svn
        gitperllib=$out/lib/perl5/site_perl
        for i in ${builtins.toString perlLibs}; do
          gitperllib=$gitperllib:$i/lib/perl5/site_perl
        done
        wrapProgram "$out/libexec/git-core/git-svn"     \
                     --set GITPERLLIB "$gitperllib"     \
                     --prefix PATH : "${subversion}/bin" ''
       else '' # replace git-svn by notification script
        notSupported $out/bin/git-svn "reinstall with config git = { svnSupport = true } set"
       '')

   + ''# Install man pages and Info manual
       make PERL_PATH="${perl}/bin/perl" cmd-list.made install install-info \
         -C Documentation ''

   + (if guiSupport then ''
       # Wrap Tcl/Tk programs
       for prog in bin/gitk libexec/git-core/git-gui
       do
         wrapProgram "$out/$prog"                       \
                     --set TK_LIBRARY "${tk}/lib/tk8.4" \
                     --prefix PATH : "${tk}/bin"
       done
     '' else ''
      # Don't wrap Tcl/Tk, replace them by notification scripts
       for prog in bin/gitk libexec/git-core/git-gui
       do
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
   + ''#
      declare -A seen
      find $out -type f | while read f; do
        sum=$(md5sum "$f");
        sum=''\${sum/ */}
        if [ -z "''\${seen["$sum"]}" ]; then
          seen["$sum"]="$f"
        else
          rm "$f"; ln -s "''\${seen["$sum"]}" "$f"
        fi
      done

     '';

  meta = {
    license = "GPLv2";
    homepage = http://git.or.cz;
    description = "Git, a popular distributed version control system";

    longDescription = ''
      Git, a popular distributed version control system designed to
      handle very large projects with speed and efficiency.
    '';

  };
}
