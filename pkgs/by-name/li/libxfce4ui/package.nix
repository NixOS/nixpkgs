{
  stdenv,
  lib,
  fetchFromGitLab,
  gettext,
  perl,
  pkg-config,
  meson,
  ninja,
  python3,
  wrapGAppsHook3,
  libice,
  libsm,
  libepoxy,
  libgtop,
  libgudev,
  libstartup_notification,
  xfconf,
  gtk3,
  libxfce4util,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  buildPackages,
  gobject-introspection,
  vala,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxfce4ui";
  version = "4.21.8";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "xfce";
    repo = "libxfce4ui";
    tag = "libxfce4ui-${finalAttrs.version}";
    hash = "sha256-nyzqV0nSQzNqTC48mN/0DeyQ9BD0dg9LcOhchYW2c+A=";
  };

  nativeBuildInputs = [
    gettext
    perl
    pkg-config
    meson
    ninja
    python3
    wrapGAppsHook3
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
    vala # vala bindings require GObject introspection
  ];

  buildInputs = [
    libice
    libsm
    libepoxy
    libgtop
    libgudev
    libstartup_notification
    xfconf
  ];

  propagatedBuildInputs = [
    gtk3
    libxfce4util
  ];

  mesonFlags = [
    (lib.mesonOption "vendor-info" "NixOS")
  ];

  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs xdt-gen-visibility
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "libxfce4ui-";
    odd-unstable = true;
  };

  meta = {
    description = "Widgets library for Xfce";
    homepage = "https://gitlab.xfce.org/xfce/libxfce4ui";
    mainProgram = "xfce4-about";
    license = with lib.licenses; [
      lgpl2Plus
      lgpl21Plus
    ];
    platforms = lib.platforms.linux;
    teams = [ lib.teams.xfce ];
  };
})
