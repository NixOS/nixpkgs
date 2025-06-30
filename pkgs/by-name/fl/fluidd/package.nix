{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  replaceVars,
  nixosTests,
  baseUrl ? "/",
}:

buildNpmPackage rec {
  pname = "fluidd";
  version = "1.34.3";

  src = fetchFromGitHub {
    owner = "fluidd-core";
    repo = "fluidd";
    tag = "v${version}";
    hash = "sha256-e3JM9QshQFHvDXvZznQBDFsOiwzxw2lz2hChw66lmMM=";
  };

  patches = [
    (replaceVars ./hardcode-version.patch {
      inherit version;
    })
  ];

  npmDepsHash = "sha256-WDquc35cwyTyVM8Il5aVYWbJqSKhR8wsMNNFgexFKYg=";

  npmBuildFlags =
    [ ]
    ++ lib.optionals (baseUrl != "/") [
      "--"
      "--base"
      "${lib.strings.removeSuffix "/" baseUrl}/"
    ];

  installPhase = ''
    mkdir -p $(dirname $out/share/fluidd/htdocs${baseUrl})
    cp -r ./dist $out/share/fluidd/htdocs${baseUrl}
  '';

  passthru.tests = {
    inherit (nixosTests) fluidd;
  };

  meta = with lib; {
    description = "Klipper web interface";
    homepage = "https://docs.fluidd.xyz";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
