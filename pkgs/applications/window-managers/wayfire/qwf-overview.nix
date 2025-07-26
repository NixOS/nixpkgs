{
  stdenv,
  lib,
  fetchFromGitea,
  gitUpdater,
  meson,
  ninja,
  pkg-config,
  wayfire,
  libGL,
  libinput,
  libxkbcommon,
  nlohmann_json,
  xcbutilwm,
}:

stdenv.mkDerivation (finalAttrs: rec {
  pname = "qwf-overview";
  version = "1.0.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "qtea";
    repo = "qwf-overview";
    tag = "v${version}";
    hash = "sha256-nyTb91n1Qz1UKGrbp7Z/Jlv25Eu6/SLI5ooYjmW9PYM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    wayfire
    libGL
    libinput
    libxkbcommon
    nlohmann_json
    xcbutilwm
  ];

  # Don't use git to determine version
  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "run_command('version.sh', 'get-vcs').stdout().strip()" "'$version'"
  '';

  env = {
    PKG_CONFIG_WAYFIRE_METADATADIR = "${placeholder "out"}/share/wayfire/metadata";
  };

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    homepage = "https://codeberg.org/qtea/qwf-overview";
    description = "Wayfire overview plugin inspired by the GNOME Activity Overview";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ teatwig ];
    inherit (wayfire.meta) platforms;
  };
})
