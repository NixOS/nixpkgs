{ fetchurl, stdenv, curl, openssl, zlib, expat, perl, gettext, cpio
, asciidoc, texinfo, xmlto, docbook2x, docbook_xsl, docbook_xml_dtd_42
, libxslt, tcl, tk, makeWrapper
, svnSupport, subversion, perlLibs
, guiSupport
}:

# `git-svn' support requires Subversion and various Perl libraries.
assert svnSupport -> (subversion != null && perlLibs != [] && subversion.perlBindings);


stdenv.mkDerivation rec {
  name = "git-1.5.6.2";

  src = fetchurl {
    url = "mirror://kernel/software/scm/git/${name}.tar.bz2";
    sha256 = "0bq4rwa9kfn5z1daszb1qvqjzy1hk3ir392bpikhmsqp9hi5yc0j";
  };

  patches = [ ./pwd.patch ./docbook2texi.patch ];

  buildInputs = [curl openssl zlib expat gettext cpio makeWrapper]
    ++ # documentation tools
       [ asciidoc texinfo xmlto docbook2x
         docbook_xsl docbook_xml_dtd_42 libxslt ]
    ++ stdenv.lib.optionals guiSupport [tcl tk];

  makeFlags = "prefix=\${out} PERL_PATH=${perl}/bin/perl SHELL_PATH=${stdenv.shell}";

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
        gitperllib=$out/lib/site_perl
        for i in ${builtins.toString perlLibs}; do
          gitperllib=$gitperllib:$i/lib/site_perl
        done
        wrapProgram "$out/bin/git-svn"                  \
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
       for prog in gitk git-gui git-citool
       do
         wrapProgram "$out/bin/$prog"                   \
                     --set TK_LIBRARY "${tk}/lib/tk8.4" \
                     --prefix PATH : "${tk}/bin"
       done
     '' else ''
      # don not wrap Tcl/Tk, replace them by notification scripts
       for prog in gitk git-gui git-citool
       do
         notSupported "$out/bin/$prog" "reinstall with config git = { guiSupport = true } set"
       done
     '')

   + ''# Wrap `git-clone'
       wrapProgram $out/bin/git-clone                   \
                   --prefix PATH : "${cpio}/bin" ''
                   
   + ''# install bash completion script
      d="$out/etc/bash_completion.d"
      ensureDir $d; cp contrib/completion/git-completion.bash "$d"
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
