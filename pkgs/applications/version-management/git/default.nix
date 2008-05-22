{ fetchurl, stdenv, curl, openssl, zlib, expat, perl, gettext, emacs, cpio
, asciidoc, texinfo, xmlto, docbook2x, docbook_xsl, docbook_xml_dtd_42
, libxslt, tcl, tk, makeWrapper
, svnSupport, subversion, perlLibs }:

# `git-svn' support requires Subversion and various Perl libraries.
# FIXME: We should make sure Subversion comes with its Perl bindings.
assert svnSupport -> (subversion != null && perlLibs != []);


stdenv.mkDerivation rec {
  name = "git-1.5.5";

  src = fetchurl {
    url = "mirror://kernel/software/scm/git/${name}.tar.bz2";
    sha256 = "0pp6hfxkcwzb415wkkn713pqsv7cv06y90s53dyhsicqqn83hj17";
  };

  patches = [ ./pwd.patch ./docbook2texi.patch ];

  buildInputs = [curl openssl zlib expat gettext cpio]
    ++ (if emacs != null then [emacs] else [])
    ++ # documentation tools
       [ asciidoc texinfo xmlto docbook2x
         docbook_xsl docbook_xml_dtd_42 libxslt ]
    ++ # Tcl/Tk
       [ tcl tk makeWrapper ];

  makeFlags="prefix=\${out} PERL_PATH=${perl}/bin/perl SHELL_PATH=${stdenv.shell}";

  postInstall =
   (if emacs != null then
	 ''# Install Emacs mode.
	   echo "installing Emacs mode..."
	   make install -C contrib/emacs prefix="$out"

	   # XXX: There are other things under `contrib' that people might want to
	   # install. ''
       else
         ''echo "NOT installing Emacs mode.  Set \`git.useEmacs' to \`true' in your"
	   echo "\`~/.nixpkgs/config.nix' file to change it." '')

   + (if svnSupport then

      ''# wrap git-svn
        gitperllib=$out/lib/site_perl
        for i in ${builtins.toString perlLibs}; do
          gitperllib=$gitperllib:$i/lib/site_perl
        done
	wrapProgram "$out/bin/git-svn"			\
		     --set GITPERLLIB "$gitperllib"    	\
		     --prefix PATH : "${subversion}/bin" ''
       else ''
       echo "NOT installing \`git-svn' since \`svnSupport' is false."
       rm $out/bin/git-svn '')

   + ''# Install man pages and Info manual
       make PERL_PATH="${perl}/bin/perl" cmd-list.made install install-info \
         -C Documentation ''

   + ''# Wrap Tcl/Tk programs
       for prog in gitk git-gui git-citool
       do
	 wrapProgram "$out/bin/$prog"			\
		     --set TK_LIBRARY "${tk}/lib/tk8.4"	\
		     --prefix PATH : "${tk}/bin"
       done ''

   + ''# Wrap `git-clone'
       wrapProgram $out/bin/git-clone			\
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
