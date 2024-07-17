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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayfire-shadows";
  version = "unstable-2024-03-28";

  src = fetchFromGitHub {
    owner = "timgott";
    repo = "wayfire-shadows";
    rev = "81699f6e4be65dcf3f7ad5155dfb4247b37b7997";
    hash = "sha256-H9pqpHoeDfNBrtVLax57CUXVhU2XT+syAUZTYSJizxw=";
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
  ];

  env = {
    PKG_CONFIG_WAYFIRE_METADATADIR = "${placeholder "out"}/share/wayfire/metadata";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/timgott/wayfire-shadows";
    description = "Wayfire plugin that adds window shadows";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rewine ];
    inherit (wayfire.meta) platforms;
  };
})
