{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
  libiio,
  libevdev,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "inputplumber";
  version = "0.77.0";

  src = fetchFromGitHub {
    owner = "ShadowBlip";
    repo = "InputPlumber";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sSLazAjwkTu4Vns8Vs4Gx47WG8fYQYJX6zhk0p139q0=";
  };

  cargoHash = "sha256-OEpv09DipaGtmlUWmvl4+Hm3DyBvSRkZaGePDy14/OU=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    udev
    libevdev
    libiio
  ];

  postInstall = ''
    cp -r rootfs/usr/* $out/
  '';

  meta = {
    description = "Open source input router and remapper daemon for Linux";
    homepage = "https://github.com/ShadowBlip/InputPlumber";
    license = lib.licenses.gpl3Plus;
    changelog = "https://github.com/ShadowBlip/InputPlumber/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ shadowapex ];
    mainProgram = "inputplumber";
  };
})
