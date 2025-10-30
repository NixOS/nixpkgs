{
  lib,
  fetchFromGitHub,
  applyPatches,
  rustPlatform,
  cmake,
  libGL,
  libinput,
  libxkbcommon,
  pkg-config,
  udev,
  wayland,
  xorg,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "stardust-xr-non-spatial-input";
  version = "0-unstable-2024-06-01";

  # applyPatches needed so that the rust build system pulls the correct lockfile
  src = applyPatches {
    src = fetchFromGitHub {
      owner = "stardustxr";
      repo = "non-spatial-input";
      rev = "5ac7f04f6876097aa8c3cf9af033d609a8a49944";
      hash = "sha256-W2wujTlj3URCq85Li0iJtSPfTf3dn8kRJueGWZPsks8=";
    };
    patches = [
      ./fix-cargo-lock.patch
    ];
  };

  cargoHash = "sha256-uAJZx/WrkQG7UDCfn/OaYvRrT3EGsbjWX+BOJir6tDs=";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    libGL
    libinput
    libxkbcommon
    udev
    wayland
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
  ];
  nativeCheckInputs = [
    versionCheckHook
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "TODO";
    homepage = "https://stardustxr.org";
    license = lib.licenses.mit;
    maintainers = lib.teams.stardust-xr.members;
    platforms = lib.platforms.linux;
  };
}
