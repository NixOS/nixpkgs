{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  libnl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chip-ota-provider-app";
  version = "2024.7.2";

  src = fetchurl {
    url = "https://github.com/home-assistant-libs/matter-linux-ota-provider/releases/download/${finalAttrs.version}/chip-ota-provider-app-x86-64";
    hash = "sha256-Ao4szcdhur79+ANIjQ9dPi7NLDnbAEUw/ISO2qc7mhc=";
  };

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    libnl
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 $src $out/bin/chip-ota-provider-app

    runHook postInstall
  '';

  meta = {
    description = "Chip OTA Provider App for x86_64 architectures";
    homepage = "https://github.com/home-assistant-libs/matter-linux-ota-provider";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.imalison ];
    platforms = [ "x86_64-linux" ];
  };
})
