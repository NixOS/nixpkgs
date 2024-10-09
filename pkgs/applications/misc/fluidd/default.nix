{ lib, stdenvNoCC, fetchurl, unzip, nixosTests }:

stdenvNoCC.mkDerivation rec {
  pname = "fluidd";
  version = "1.30.4";

  src = fetchurl {
    name = "fluidd-v${version}.zip";
    url = "https://github.com/cadriel/fluidd/releases/download/v${version}/fluidd.zip";
    sha256 = "sha256-r9RYNfbMa0axxS5kVBsFmvnuznsZz4s0ZfsIJVczHlI=";
  };

  nativeBuildInputs = [ unzip ];

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    mkdir fluidd
    unzip $src -d fluidd
  '';

  installPhase = ''
    mkdir -p $out/share/fluidd
    cp -r fluidd $out/share/fluidd/htdocs
  '';

  passthru.tests = { inherit (nixosTests) fluidd; };

  meta = with lib; {
    description = "Klipper web interface";
    homepage = "https://docs.fluidd.xyz";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
