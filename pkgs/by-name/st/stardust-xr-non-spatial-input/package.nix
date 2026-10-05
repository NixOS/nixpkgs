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
  version = "0.52.0";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "non-spatial-input";
    tag = finalAttrs.version;
    hash = "sha256-VOaZzz3XIpyOSzBqI5+TUe1vJtKxGXUFomU7wTyBxnE=";
  };

  cargoHash = "sha256-jXtFBKli3R8IA+nyQIsik/V+WcevV+ReB/6X6XeuETg=";

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
