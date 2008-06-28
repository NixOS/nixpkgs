{ fetchurl, stdenv, curl, openssl, zlib, expat, perl, gettext, cpio
, asciidoc, texinfo, xmlto, docbook2x, docbook_xsl, docbook_xml_dtd_42
, libxslt, tcl, tk, makeWrapper
, svnSupport, subversion, perlLibs
, guiSupport
}:

# `git-svn' support requires Subversion and various Perl libraries.
# FIXME: We should make sure Subversion comes with its Perl bindings.
assert svnSupport -> (subversion != null && perlLibs != []);


stdenv.mkDerivation rec {
  name = "git-1.5.6.1";

  src = fetchurl {
    url = "mirror://kernel/software/scm/git/${name}.tar.bz2";
    sha256 = "11k5d986y9clmb2lywkdv1g1gybz38irmcp4rx8l4jfmk7l62sh7";
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
       else ''
       echo "NOT installing \`git-svn' since \`svnSupport' is false."
       rm $out/bin/git-svn '')

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
     '' else "")

   + ''# Wrap `git-clone'
       wrapProgram $out/bin/git-clone                   \
                   --prefix PATH : "${cpio}/bin" '';

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
