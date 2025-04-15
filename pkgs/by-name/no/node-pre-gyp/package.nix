{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

buildNpmPackage rec {
  pname = "node-pre-gyp";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "mapbox";
    repo = "node-pre-gyp";
    tag = "v${version}";
    hash = "sha256-i7iBy+X9zBKrrbIwVa61y9cbmHJmqeacXrZk+XGRok8=";
  };

  npmDepsHash = "sha256-0Xa5bByTskrQ8v2O1FUxtQzRb1ZEV0TvUhe8hh05QHI=";

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
