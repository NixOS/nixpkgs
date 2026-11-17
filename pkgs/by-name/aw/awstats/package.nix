{
  lib,
  fetchurl,
  perlPackages,
  jdk,
}:

perlPackages.buildPerlPackage rec {
  pname = "awstats";
  version = "8.0";

  src = fetchurl {
    url = "mirror://sourceforge/awstats/awstats-${version}.tar.gz";
    sha256 = "sha256-Pvdv+WxTmEd92KERNOJm5TikhwZ/aQajrIo4v9EcEeA=";
  };

  postPatch = ''
    substituteInPlace wwwroot/cgi-bin/awstats.pl \
      --replace /usr/share/awstats/ "$out/wwwroot/cgi-bin/"
  '';

  outputs = [
    "bin"
    "out"
    "doc"
  ]; # bin just links the user-run executable

  propagatedBuildOutputs = [ ]; # otherwise out propagates bin -> cycle

  buildInputs = with perlPackages; [
    JSONXS
    TryTiny
  ];

  preConfigure = ''
    touch Makefile.PL
    patchShebangs .
  '';

  # build our own JAR
  preBuild = ''
    (
      cd wwwroot/classes/src
      rm ../*.jar
      PATH="${jdk}/bin" "$(type -P perl)" Makefile.pl
      test -f ../*.jar
    )
  '';

  doCheck = false;

  installPhase = ''
    mkdir "$out"
    mv wwwroot "$out/wwwroot"
    rm -r "$out/wwwroot/classes/src/"

    mkdir -p "$out/share/awstats"
    mv tools "$out/share/awstats/tools"

    mkdir -p "$bin/bin"
    ln -s "$out/wwwroot/cgi-bin/awstats.pl" "$bin/bin/awstats"

    mkdir -p "$doc/share/doc"
    mv README.md docs/
    mv docs "$doc/share/doc/awstats"
  '';

  meta = {
    changelog = "https://www.awstats.org/docs/awstats_changelog.txt";
    description = "Real-time logfile analyzer to get advanced statistics";
    homepage = "https://awstats.org";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    mainProgram = "awstats";
  };
}
