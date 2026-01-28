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
  version = "1.34.4";

  src = fetchFromGitHub {
    owner = "fluidd-core";
    repo = "fluidd";
    tag = "v${version}";
    hash = "sha256-EixAax+Bd0IoGdk6Q9FoMQoWAa1U+O3SYeYEnuonHEI=";
  };

  patches = [
    (replaceVars ./hardcode-version.patch {
      inherit version;
    })
  ];

  npmDepsHash = "sha256-08tm+NuDLwilwo7SCmncIGAbEIW0tJLZi1HaoWGgAJA=";

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
