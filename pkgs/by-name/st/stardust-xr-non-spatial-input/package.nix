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
  libx11,
  libxcursor,
  libxrandr,
  libxi,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stardust-xr-non-spatial-input";
  version = "0.51.1";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "non-spatial-input";
    tag = finalAttrs.version;
    hash = "sha256-CWPEu+WvTtCo2zUXzyQkFcb5bFG9yVu/OnjPuoGKDGA=";
  };

  cargoHash = "sha256-QZaVDMeuxqHy9iQngb/wpv/P+KxevkoQqGojYIVzo2s=";

  __structuredAttrs = true;
  strictDeps = true;
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
    libx11
    libxcursor
    libxrandr
    libxi
  ];
  nativeCheckInputs = [
    versionCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Utilities that allow using non-spatial (e.g. keyboard and mouse) inputs in Stardust";
    homepage = "https://stardustxr.org";
    license = lib.licenses.mit;
    teams = with lib.teams; [ stardust-xr ];
    platforms = lib.platforms.unix;
  };
})
