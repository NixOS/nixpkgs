{
  stdenv,
  lib,
  fetchFromGitLab,
  gettext,
  pkg-config,
  python3,
  vala,
  xfce4-dev-tools,
  wrapGAppsNoGuiHook,
  glib,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  buildPackages,
  gobject-introspection,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxfce4util";
  version = "4.20.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "xfce";
    repo = "libxfce4util";
    tag = "libxfce4util-${finalAttrs.version}";
    hash = "sha256-QlT5ev4NhjR/apbgYQsjrweJ2IqLySozLYLzCAnmkfM=";
  };

  nativeBuildInputs = [
    gettext
    pkg-config
    python3
    xfce4-dev-tools
    wrapGAppsNoGuiHook
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
    vala # vala bindings require GObject introspection
  ];

  propagatedBuildInputs = [
    glib
  ];

  postPatch = ''
    patchShebangs xdt-gen-visibility
  '';

  configureFlags = [ "--enable-maintainer-mode" ];
  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    rev-prefix = "libxfce4util-";
    odd-unstable = true;
  };

  meta = {
    description = "Extension library for Xfce";
    homepage = "https://gitlab.xfce.org/xfce/libxfce4util";
    mainProgram = "xfce4-kiosk-query";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.xfce ];
  };
})
