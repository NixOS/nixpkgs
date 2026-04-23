{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libqalculate,
  gtk3,
  gtk-mac-integration-gtk3,
  curl,
  wrapGAppsHook3,
  desktopToDarwinBundle,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qalculate-gtk";
  version = "5.10.0";

  src = fetchFromGitHub {
    owner = "qalculate";
    repo = "qalculate-gtk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JZfolSRLRLtv529f25lEPYOlz+y+EdRqKA0Y5d1dK3s=";
  };

  hardeningDisable = [ "format" ];

  # TODO: Remove these patches when updating to 5.11 (See https://github.com/Qalculate/qalculate-gtk/pull/705)
  postPatch = ''
    substituteInPlace configure.ac \
      --replace-fail 'AM_CONDITIONAL(PLATFORM_MACOS, test "$build_macos" = "yes")' \
                     'AM_CONDITIONAL(PLATFORM_MACOS, test "$build_mac" = "yes")'

    substituteInPlace src/Makefile.am \
      --replace-fail '$(GTK_MAC_CFLAGS)' '@GTK_MAC_CFLAGS@' \
      --replace-fail '$(GTK_MAC_LIBS)' '@GTK_MAC_LIBS@'
  '';

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    wrapGAppsHook3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ desktopToDarwinBundle ];

  buildInputs = [
    libqalculate
    gtk3
    curl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    gtk-mac-integration-gtk3
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Ultimate desktop calculator";
    homepage = "http://qalculate.github.io";
    maintainers = with lib.maintainers; [
      doronbehar
      pentane
      aleksana
    ];
    license = lib.licenses.gpl2Plus;
    mainProgram = "qalculate-gtk";
    platforms = lib.platforms.all;
  };
})
