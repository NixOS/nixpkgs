{
  cpio,
  xar,
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  driver-version ? null,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "karabiner-driverkit-virtualhiddevice";
  version = if driver-version != null then driver-version else "6.2.0";

  src = fetchFromGitHub {
    owner = "pqrs-org";
    repo = "Karabiner-DriverKit-VirtualHIDDevice";
    tag = "v6.2.0";
    sha256 = "sha256-Gw40F9gB+9sDg8swiOCfpCbc1gNHR0NbISOEJmpkWz8=";
  };
  nativeBuildInputs = [
    cpio
    xar
  ];
  unpackPhase = ''
    runHook preUnpack
    xar -xf $src/dist/Karabiner-DriverKit-VirtualHIDDevice-${finalAttrs.version}.pkg
    zcat Payload | cpio -i
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -R ./Applications ./Library $out
    find $out -name '._embedded.provisionprofile' | xargs rm
    runHook postInstall
  '';
  dontFixup = true;
  passthru.updateScript = nix-update-script { };
  meta = {
    changelog = "https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases/tag/v${finalAttrs.version}";
    description = "Implements a virtual keyboard and virtual mouse using DriverKit on macOS";
    homepage = "https://karabiner-elements.pqrs.org/";
    maintainers = with lib.maintainers; [ auscyber ];
    license = lib.licenses.unlicense;
    platforms = lib.platforms.darwin;
  };
})
