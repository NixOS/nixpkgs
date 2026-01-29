{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  jq,
}:

buildNpmPackage rec {
  pname = "bentopdf";
  version = "1.15.4";

  src = fetchFromGitHub {
    owner = "alam00000";
    repo = "bentopdf";
    rev = "v${version}";
    hash = "sha256-6CuAO8dgk7S9cgiFcwELXgIS1Cyol8Vk26LTtRn6oE0=";
  };

  npmDepsHash = "sha256-hvkES1/rfBDEIMyeGFDkGe/YwXZgYvy/RzHyc9dCrSI=";

  nativeBuildInputs = [ jq ];

  postPatch = ''
    # Remove dependencies from package.json that are provided as local files
    jq 'del(.dependencies."embedpdf-snippet") | del(.dependencies."xlsx")' package.json > package.json.tmp && mv package.json.tmp package.json

    # Remove dependencies from package-lock.json
    jq '
      del(.packages."node_modules/embedpdf-snippet") |
      del(.packages."node_modules/xlsx") |
      del(.packages."".dependencies."embedpdf-snippet") |
      del(.packages."".dependencies."xlsx")
    ' package-lock.json > package-lock.json.tmp && mv package-lock.json.tmp package-lock.json
  '';

  makeCacheWritable = true;

  # Re-add local dependencies before build
  preBuild = ''
    npm install --no-save vendor/embedpdf/embedpdf-snippet-1.5.0.tgz vendor/sheetjs/xlsx-0.20.2.tgz
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/bentopdf
    cp -r dist/* $out/share/bentopdf/
    runHook postInstall
  '';

  meta = {
    description = "A Privacy First PDF Toolkit";
    homepage = "https://github.com/alam00000/bentopdf";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ moritzrfs ];
    platforms = lib.platforms.all;
  };
}
