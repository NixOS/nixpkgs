{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
}:

buildNpmPackage {
  pname = "deye-dummycloud";
  version = "c36009e";

  src = fetchFromGitHub {
    owner = "Hypfer";
    repo = "deye-microinverter-cloud-free";
    rev = "c36009e5c1711aa0f76bd17d63e33322535a87f9";
    hash = "sha256-ARd2Vi305lErYAZ3FN+hXocHCHxC3gr6mbrPn032zxc=";
  };
  sourceRoot = "source/dummycloud";
  npmDepsHash = "sha256-zN+iE9M12osr72z9Jvp80SdLeGahz7drvF+kx7914AE=";

  patches = [ ./0001-packge.json-Remove-dev-dependencies-for-repoducible-.patch ];

  dontNpmBuild = true;

  meta = {
    description = "A dummy cloud server for DEYE microinverters (Node.js) and bridge to mqtt";
    homepage = "https://github.com/Hypfer/deye-microinverter-cloud-free";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ poeschel ];
    platforms = lib.platforms.linux;
  };
}
