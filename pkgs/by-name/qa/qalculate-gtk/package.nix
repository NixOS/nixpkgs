{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    # Is meaningfull only for Darwin but is better applying unconditionally.
    # Can be removed in 5.11 probably, see:
    # https://github.com/Qalculate/qalculate-gtk/pull/705
    (fetchpatch {
      url = "https://github.com/Qalculate/qalculate-gtk/commit/2f1b6a32d98f122d44d158c20f79a5b9aaf9669f.patch";
      hash = "sha256-v9T8wWvqlI9l6BUszf/575qmoFvh88Cdj/m2XqV8Q4k=";
    })
  ];

  hardeningDisable = [ "format" ];

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
