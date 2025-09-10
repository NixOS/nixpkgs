{
  buildGoModule,
  fetchFromGitHub,
  lib,
  pkg-config,
  nix-update-script,
  alsa-lib,
  libGL,
  libxkbcommon,
  vulkan-headers,
  wayland,
  xorg,
}:

buildGoModule {
  pname = "sointu";
  version = "0.4.1-unstable-2025-08-13";

  src = fetchFromGitHub {
    owner = "vsariola";
    repo = "sointu";
    rev = "74fea4138fd788eddeb726440c872937de56fd1c";
    hash = "sha256-kHK35Bt/+ucPCsFE3p72J3jSHzhOK9QKtJPG+3grBvs=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    libGL
    libxkbcommon
    vulkan-headers
    wayland
    xorg.libX11
    xorg.libXcursor
    xorg.libXfixes
  ];

  proxyVendor = true;
  vendorHash = "sha256-gLDLKqu6k7/nwv6xHUE6MIYrbQFfVFAuUiMbLptcE5k=";

  subPackages = [
    "cmd/sointu-track"
    "cmd/sointu-compile"
    "cmd/sointu-play"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fork of 4klang that can target 386, amd64 and WebAssembly";
    mainProgram = "sointu-track";
    homepage = "https://github.com/vsariola/sointu";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ martinimoe ];
  };
}
