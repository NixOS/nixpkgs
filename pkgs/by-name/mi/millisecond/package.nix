{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  python313,
  gobject-introspection,
  gtk4,
  desktop-file-utils,
  appstream,
  glib,
  wrapGAppsHook4,
  libadwaita,
}:

let
  pythonEnv = python313.withPackages (p: [
    p.pygobject3
  ]);
in

stdenv.mkDerivation (finalAttrs: {
  pname = "millisecond";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "gaheldev";
    repo = "Millisecond";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SMGcSlbOfBX5gAwB7CaHRthf9EN5QWAN9ZzrcbQXtm8=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    glib
    gobject-introspection
    gtk4
    meson
    ninja
    pkg-config
    pythonEnv
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
  ];

  meta = {
    homepage = "https://github.com/gaheldev/Millisecond";
    description = "Optimize your Linux system for low latency audio";
    mainProgram = "millisecond";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      backtail
    ];
    platforms = lib.platforms.linux;
  };
})
