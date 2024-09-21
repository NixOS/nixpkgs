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
, gtk3
, glibmm
, xcbutilwm
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wwp-switcher";
  version = "0-unstable-2024-07-23";

  src = fetchFromGitHub {
    owner = "wb9688";
    repo = "wwp-switcher";
    rev = "d0cd97534a2a6355697efecb7bcf8f85f5dc4b5b";
    hash = "sha256-cU8INUb+JXlSCM7cAOUBU7z7W0IM6pAGN0izGdFYntc=";
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
    gtk3
    glibmm
    xcbutilwm
  ];

  env = {
    PKG_CONFIG_WAYFIRE_METADATADIR = "${placeholder "out"}/share/wayfire/metadata";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/wb9688/wwp-switcher";
    description = "Plugin to switch active window";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rewine ];
    inherit (wayfire.meta) platforms;
  };
})
