{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  replaceVars,
  nixosTests,
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

  installPhase = ''
    mkdir -p $out/share/fluidd
    cp -r dist $out/share/fluidd/htdocs
  '';

  passthru.tests = { inherit (nixosTests) fluidd; };

  meta = {
    description = "Klipper web interface";
    homepage = "https://docs.fluidd.xyz";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ zhaofengli ];
  };
}
