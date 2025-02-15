{ stdenv, fetchurl, libnl, autoPatchelfHook, lib }:

stdenv.mkDerivation rec {
  pname = "chip-ota-provider-app";
  version = "2024.7.2";

  src = fetchurl {
    url = "https://github.com/home-assistant-libs/matter-linux-ota-provider/releases/download/${version}/chip-ota-provider-app-x86-64";
    sha256 = "sha256-Ao4szcdhur79+ANIjQ9dPi7NLDnbAEUw/ISO2qc7mhc=";
  };

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [ libnl autoPatchelfHook stdenv.cc.cc.lib ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/chip-ota-provider-app
    chmod u+wx $out/bin/chip-ota-provider-app
  '';

  meta = {
    description = "Chip OTA Provider App for x86_64 architectures";
    homepage = "https://github.com/home-assistant-libs/matter-linux-ota-provider";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.imalison ];
    platforms = [ "x86_64-linux" ];
  };
}
