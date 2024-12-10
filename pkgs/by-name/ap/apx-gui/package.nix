{
  lib,
  stdenv,
  fetchFromGitHub,
  appstream-glib,
  desktop-file-utils,
  gobject-introspection,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  python3,
  wrapGAppsHook4,
  apx,
  gnome-console,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "apx-gui";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "Vanilla-OS";
    repo = "apx-gui";
    rev = "v${finalAttrs.version}";
    hash = "sha256-orP5kAsoXX0zyDskeIPKKHNt5c757eUm9un4Ws6uFYA=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkg-config
    (python3.withPackages (ps: [ ps.pygobject3 ]))
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${
        lib.makeBinPath [
          apx
          gnome-console
        ]
      }"
    )
  '';

  meta = {
    description = "A GUI frontend for Apx in GTK 4 and Libadwaita";
    homepage = "https://github.com/Vanilla-OS/apx-gui";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ chewblacka ];
    mainProgram = "apx-gui";
  };
})
