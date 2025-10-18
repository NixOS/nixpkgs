{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  node-pre-gyp,
}:
let
  version = "5.1.1";
in
buildNpmPackage {
  pname = "bcrypt-lib";
  inherit version;

  src = fetchFromGitHub {
    owner = "kelektiv";
    repo = "node.bcrypt.js";
    rev = "refs/tags/v${version}";
    hash = "sha256-mgfYEgvgC5JwgUhU8Kn/f1D7n9ljnIODkKotEcxQnDQ=";
  };

  npmDepsHash = "sha256-CPXZ/yLEjTBIyTPVrgCvb+UGZJ6yRZUJOvBSZpLSABY=";

  nativeBuildInputs = [
    node-pre-gyp
  ];

  npmBuildScript = "install";

  buildPhase = ''
    runHook preBuild
    node-pre-gyp install --build-from-source
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r lib -t $out
    runHook postInstall
  '';

  meta = {
    description = "Library that helps with hashing passwords";
    homepage = "https://github.com/kelektiv/node.bcrypt.js";
    license = with lib.licenses; [ mit ];
    platforms = with lib.platforms; linux ++ darwin ++ windows;
    maintainers = with lib.maintainers; [ pluiedev ];
  };
}
