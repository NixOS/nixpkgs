{
  buildGoModule,
  fetchFromGitHub,
  lib,
  pkg-config,
  nix-update-script,
  alsa-lib,
  libGL,
  libxcb,
  libxkbcommon,
  vulkan-headers,
  wayland,
  xorg,
}:

buildGoModule rec {
  pname = "sointu";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "vsariola";
    repo = "sointu";
    tag = "v${version}";
    hash = "sha256-xHKD+zArsdQVffwbbSOOdzC6o5sxpez8VLAwIzV5X4E=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    libGL
    libxcb
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
