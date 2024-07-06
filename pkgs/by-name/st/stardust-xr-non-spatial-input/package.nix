{
  lib,
  fetchFromGitHub,
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

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "non-spatial-input";
    rev = "42a23ba87322cf93602a81025f3ba1710d26dc1e";
    hash = "sha256-W5oAv9R8GsSPna1B/7LsUnDy74dtqZlR0gvme4CFapU=";
  };

  patches = [
    ./fix-cargo-lock.patch
  ];

  cargoHash = "sha256-AAe5WMqvne2WujZuGottWuZi9MORl/LiG2IYwB9XhHE=";

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
    maintainers = with lib.maintainers; [ pandapip1 ];
    platforms = lib.platforms.linux;
  };
}
