{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

buildNpmPackage rec {
  pname = "node-pre-gyp";
  version = "1.0.11";

  src = fetchFromGitHub {
    owner = "mapbox";
    repo = "node-pre-gyp";
    rev = "refs/tags/v${version}";
    hash = "sha256-O0PLEy2bEIrypaC+WyQJI5kfkqBBps029CujBKkzZ6o=";
  };

  npmDepsHash = "sha256-pZEnyovFp+wOz7D73JpNfEsVNkukPe9sGt1oIO8Tvnc=";

  dontNpmBuild = true;

  postInstall = ''
    mv $out/bin/@mapbox/node-pre-gyp $out/bin
    rmdir $out/bin/@mapbox
  '';

  meta = {
    changelog = "https://github.com/mapbox/node-pre-gyp/blob/${src.rev}/CHANGELOG.md";
    description = "Node.js tool for easy binary deployment of C++ addons";
    homepage = "https://github.com/mapbox/node-pre-gyp";
    license = lib.licenses.bsd3;
    mainProgram = "node-pre-gyp";
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
