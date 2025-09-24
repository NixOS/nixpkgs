{
  stdenv,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  meson,
  ninja,
  pkg-config,
  wayfire,
  libxkbcommon,
  libGL,
  libinput,
  xcbutilwm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayfire-shadows";
  version = "0-unstable-2025-03-04";

  src = fetchFromGitHub {
    owner = "timgott";
    repo = "wayfire-shadows";
    rev = "8257a4f04670d8baf29e2d9cee0d78f978f0233f";
    hash = "sha256-cRayvjbolVxWtr1PbLSjxtIpZogTJaoAMxPOcZ+zBT8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    wayfire
    libxkbcommon
    libGL
    libinput
    xcbutilwm
  ];

  env = {
    PKG_CONFIG_WAYFIRE_METADATADIR = "${placeholder "out"}/share/wayfire/metadata";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/timgott/wayfire-shadows";
    description = "Wayfire plugin that adds window shadows";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wineee ];
    inherit (wayfire.meta) platforms;
  };
})
