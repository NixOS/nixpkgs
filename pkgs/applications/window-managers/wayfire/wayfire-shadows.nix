{ stdenv
, lib
, fetchFromGitHub
, unstableGitUpdater
, meson
, ninja
, pkg-config
, wayfire
, libxkbcommon
, libGL
, libinput
, xcbutilwm
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayfire-shadows";
  version = "0-unstable-2024-08-30";

  src = fetchFromGitHub {
    owner = "timgott";
    repo = "wayfire-shadows";
    rev = "11c8ab63c1cde663a38502c6ecaeec980920c4d1";
    hash = "sha256-/utqJevG7fn/kX81eDIN/SDvVa3rzNBe1crkHfMx8qo=";
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
    maintainers = with lib.maintainers; [ rewine ];
    inherit (wayfire.meta) platforms;
  };
})
