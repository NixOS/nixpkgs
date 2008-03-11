{ fetchurl, stdenv, curl, openssl, zlib, expat, perl, gettext, emacs
, asciidoc, texinfo, xmlto, docbook2x, docbook_xsl, docbook_xml_dtd_42
, libxslt }:

stdenv.mkDerivation rec {
  name = "git-1.5.4.2";

  src = fetchurl {
    url = "mirror://kernel/software/scm/git/${name}.tar.bz2";
    sha256 = "089n3da06k19gzhacsqgaamgx5hy5r50r2b4a626s87w44mj78sn";
  };

  buildInputs = [curl openssl zlib expat gettext]
    ++ (if emacs != null then [emacs] else [])
    ++ # documentation tools
       [ asciidoc texinfo xmlto docbook2x
         docbook_xsl docbook_xml_dtd_42 libxslt ];

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
	   echo "\`~/.nixpkgs/config.nix' file to change it."'')
   + ''# Install man pages and Info manual
       make PERL_PATH="${perl}/bin/perl" cmd-list.made install install-info \
         -C Documentation'';

  meta = {
    license = "GPLv2";
    homepage = http://git.or.cz;
    description = ''Git, a popular distributed version control system
                    designed to handle very large projects with speed
		    and efficiency.'';
  };
}
