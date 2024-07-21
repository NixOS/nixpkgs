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
  version = "unstable-2023-09-09";

  src = fetchFromGitHub {
    owner = "wb9688";
    repo = "wwp-switcher";
    rev = "04711a0db133a899f507a86e81897296b793b4f3";
    hash = "sha256-qMyEhSZJNxAoaELKI2h1v59QJnKJzFa76Q4/WtZqpIU";
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
