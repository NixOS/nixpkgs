{ stdenv, fetchgit, python, asciidoc, xmlto, pysqlite, makeWrapper }:

let
  version = "3.20110902";
in
stdenv.mkDerivation {
  name = "git-bz";

  src = fetchgit {
    url = "git://git.fishsoup.net/git-bz";
    rev = "refs/heads/master";
  };

  buildInputs = [
    makeWrapper python pysqlite # asciidoc xmlto
  ];

  buildPhase = ''
    true
    # make git-bz.1
  '';

  installPhase = ''
    mkdir -p $out
    mkdir -p $out/bin
    cp git-bz $out/bin
    wrapProgram $out/bin/git-bz \
      --prefix PYTHONPATH : "$(toPythonPath $python):$(toPythonPath $pysqlite)"
  '';

  meta = {
    homepage = "http://git.fishsoup.net/cgit/git-bz/";
    description = "integration of git with Bugzilla";
    license = stdenv.lib.licenses.gpl2;

    longDescription = ''
      git-bz is a tool for integrating the Git command line with the
      Bugzilla bug-tracking system. Operations such as attaching patches to
      bugs, applying patches in bugs to your current tree, and closing bugs
      once you've pushed the fixes publically can be done completely from
      the command line without having to go to your web browser.

      Authentication for git-bz is done by reading the cookies for the
      Bugzilla host from your web browser. In order to do this, git-bz needs
      to know how to access the cookies for your web browser; git-bz
      currently is able to do this for Firefox, Epiphany, Galeon and
      Chromium on Linux.
    '';

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.pierron ];
    broken = true;
  };
}
