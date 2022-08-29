{ lib, stdenvNoCC, fetchurl, unzip }:

stdenvNoCC.mkDerivation rec {
  pname = "fluidd";
  version = "1.20.0";

  src = fetchurl {
    name = "fluidd-v${version}.zip";
    url = "https://github.com/cadriel/fluidd/releases/download/v${version}/fluidd.zip";
    sha256 = "sha256-zDCvRwAtjBbBOa5D1k7khZGXeql5COMlWMi/dpwiiYM=";
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

  meta = with lib; {
    description = "Klipper web interface";
    homepage = "https://docs.fluidd.xyz";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
