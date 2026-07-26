{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  wayland,
  wayland-scanner,
  wayland-protocols,
  unstableGitUpdater,
  pixman,
  fcft,
  writeText,
  # Boolean flags
  withCustomConfigH ? (configH != null),
  # Configurable options
  configH ? null,
}:

stdenv.mkDerivation {
  pname = "dwlb";
  version = "0-unstable-2025-05-20";

  src = fetchFromGitHub {
    owner = "kolunmi";
    repo = "dwlb";
    rev = "48dbe00bdb98a1ae6a0e60558ce14503616aa759";
    hash = "sha256-S0jkoELkF+oEmXqiWZ8KJYtWAHEXR/Y93jl5yHgUuSM=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    wayland-scanner
    wayland-protocols
    pixman
    fcft
    wayland
  ];

  # Allow alternative config.def.h usage. Taken from dwl.nix.
  postPatch =
    let
      configFile =
        if lib.isDerivation configH || builtins.isPath configH then
          configH
        else
          writeText "config.h" configH;
    in
    lib.optionalString withCustomConfigH "cp ${configFile} config.h";

  env = {
    PREFIX = placeholder "out";
  };

  outputs = [
    "out"
    "man"
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Fast, feature-complete bar for dwl";
    homepage = "https://github.com/kolunmi/dwlb";
    license = lib.licenses.gpl3Plus;
    mainProgram = "dwlb";
    maintainers = with lib.maintainers; [
      bot-wxt1221
      lonyelon
    ];
    platforms = wayland.meta.platforms;
  };
}
