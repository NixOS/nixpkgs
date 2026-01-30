{
  fetchFromGitHub,
  glib,
  gobject-introspection,
  meson,
  ninja,
  pkg-config,
  lib,
  stdenv,
  wrapGAppsHook3,
  libxmlb,
  gtk3,
  gvfs,
  cinnamon-desktop,
  xapp,
  xapp-symbolic-icons,
  xdg-user-dirs,
  libexif,
  json-glib,
  exempi,
  intltool,
  shared-mime-info,
  cinnamon-translations,
  libgsf,
  python3,
}:

let
  # For action-layout-editor.
  pythonEnv = python3.withPackages (
    pp: with pp; [
      pycairo
      pygobject3
      python-xapp
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "nemo";
  version = "6.6.3";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "nemo";
    rev = finalAttrs.version;
    hash = "sha256-jsAKNKpNsheyugI6dVQAYYrOTmHLDjJCbjlWmAChFgU=";
  };

  patches = [
    # Load extensions from NEMO_EXTENSION_DIR environment variable
    # https://github.com/NixOS/nixpkgs/issues/78327
    ./load-extensions-from-env.patch
  ];

  outputs = [
    "out"
    "dev"
    "man"
  ];

  buildInputs = [
    glib
    gtk3
    cinnamon-desktop
    libxmlb # action-layout-editor
    pythonEnv
    xapp
    libexif
    exempi
    gvfs
    libgsf
    json-glib
  ];

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    wrapGAppsHook3
    intltool
    shared-mime-info
    gobject-introspection
  ];

  mesonFlags = [
    # use locales from cinnamon-translations
    "--localedir=${cinnamon-translations}/share/locale"
  ];

  postInstall = ''
    # This fixes open as root and handles nemo-with-extensions well.
    # https://github.com/NixOS/nixpkgs/issues/297570
    substituteInPlace $out/share/polkit-1/actions/org.nemo.root.policy \
      --replace-fail "$out/bin/nemo" "/run/current-system/sw/bin/nemo"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
       --prefix XDG_DATA_DIRS : "${
         lib.makeSearchPath "share" [
           # For non-fd.o icons.
           xapp
           xapp-symbolic-icons
         ]
       }"
       --prefix PATH : "${
         lib.makeBinPath [
           # For xdg-user-dirs-update.
           xdg-user-dirs
         ]
       }"
    )
  '';

  # Taken from libnemo-extension.pc.
  passthru.extensiondir = "lib/nemo/extensions-3.0";

  meta = {
    homepage = "https://github.com/linuxmint/nemo";
    description = "File browser for Cinnamon";
    license = [
      lib.licenses.gpl2
      lib.licenses.lgpl2
    ];
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
    mainProgram = "nemo";
  };
})
