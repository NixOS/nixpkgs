{ stdenv, fetchgit
, asciidoc, docbook_xml_dtd_45, docbook_xsl, libxslt, makeWrapper, xmlto
, pythonPackages }:

stdenv.mkDerivation rec {
  name = "git-bz-${version}";
  version = "3.2015-09-08";

  src = fetchgit {
    sha256 = "19d9c81d4eeabe87079d8f60e4cfa7303f776f5a7c9874642cf2bd188851d029";
    rev = "e17bbae7a2ce454d9f69c32fc40066995d44913d";
    url = "git://git.fishsoup.net/git-bz";
  };

  nativeBuildInputs = [
    asciidoc docbook_xml_dtd_45 docbook_xsl libxslt makeWrapper xmlto
  ];
  buildInputs = []
    ++ (with pythonPackages; [ python pysqlite ]);

  postPatch = ''
    patchShebangs configure

    # Don't create a .html copy of the man page that isn't installed anyway:
    substituteInPlace Makefile --replace "git-bz.html" ""
  '';

  postInstall = ''
    wrapProgram $out/bin/git-bz \
      --prefix PYTHONPATH : "$(toPythonPath "${pythonPackages.pysqlite}")"
  '';

  meta = with stdenv.lib; {
    description = "Bugzilla integration for git";
    longDescription = ''
      git-bz is a tool for integrating the Git command line with the
      Bugzilla bug-tracking system. Operations such as attaching patches to
      bugs, applying patches in bugs to your current tree, and closing bugs
      once you've pushed the fixes publicly can be done completely from
      the command line without having to go to your web browser.

      Authentication for git-bz is done by reading the cookies for the
      Bugzilla host from your web browser. In order to do this, git-bz needs
      to know how to access the cookies for your web browser; git-bz
      currently is able to do this for Firefox, Epiphany, Galeon and
      Chromium on Linux.
    '';
    license = licenses.gpl2Plus;
    homepage = http://git.fishsoup.net/cgit/git-bz/;

    maintainers = with maintainers; [ nckx ];
    platforms = platforms.linux;
  };
}
