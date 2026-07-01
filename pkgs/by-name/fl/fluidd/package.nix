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
  version = "1.36.2";

  src = fetchFromGitHub {
    owner = "fluidd-core";
    repo = "fluidd";
    tag = "v${version}";
    hash = "sha256-nf0H1yk+BczzvSMw5mcXz6LfcvyMF5q4teYBtwsrLOk=";
  };

  patches = [
    (replaceVars ./hardcode-version.patch {
      inherit version;
    })
  ];

  npmDepsHash = "sha256-uyrfPXm+bIjjKn4eABlfNowYzvEME0ahVvwlM9+e2Kc=";

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

  meta = {
    description = "Klipper web interface";
    homepage = "https://docs.fluidd.xyz";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ zhaofengli ];
  };
}
