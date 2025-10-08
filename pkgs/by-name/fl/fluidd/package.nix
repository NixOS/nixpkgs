{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  replaceVars,
  nixosTests,
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

  installPhase = ''
    mkdir -p $out/share/fluidd
    cp -r dist $out/share/fluidd/htdocs
  '';

  passthru.tests = { inherit (nixosTests) fluidd; };

  meta = with lib; {
    description = "Klipper web interface";
    homepage = "https://docs.fluidd.xyz";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
