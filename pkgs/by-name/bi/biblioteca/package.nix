{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  desktop-file-utils,
  glib,
  gjs,
  blueprint-compiler,
  pkg-config,
  gtk4,
  gobject-introspection,
  libadwaita,
  webkitgtk,
  coreutils,
  makeShellWrapper,
  wrapGAppsHook4,
  glib-networking,
  symlinkJoin,
  nix-update-script,
  extraDocsPackage ? [ ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "biblioteca";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "workbenchdev";
    repo = "Biblioteca";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-9AL8obvXB/bgqhTw8VE30OytNFQmxvJ6TYGN8ir+NfI=";
  };

  patches = [
    ./dont-use-flatpak.patch # From https://gitlab.archlinux.org/archlinux/packaging/packages/biblioteca/-/blob/main/biblioteca-no-flatpak.patch?ref_type=heads
  ];

  nativeBuildInputs = [
    meson
    ninja
    desktop-file-utils
    makeShellWrapper
    gjs
    wrapGAppsHook4
    pkg-config
  ];

  buildInputs = [
    glib
    gtk4
    gobject-introspection
    libadwaita
    webkitgtk
    glib-networking
  ];

  docPath = symlinkJoin {
    name = "biblioteca-docs";
    paths = [
      gtk4.devdoc
      glib.devdoc
      libadwaita.devdoc
      webkitgtk.devdoc
      gobject-introspection.devdoc
    ]
    ++ extraDocsPackage;
  };

  postPatch = ''
    substituteInPlace src/meson.build \
      --replace-fail "/app/bin/blueprint-compiler" "${lib.getExe blueprint-compiler}" \

    patchShebangs .

    substituteInPlace build-aux/build-index.js \
      --replace-fail "/usr/bin/env -S gjs -m" "${coreutils}/bin/env -S ${gjs}/bin/gjs -m" \
      --replace-fail "/app/share/doc" "${finalAttrs.docPath}/share/doc"

    substituteInPlace src/Shortcuts.js \
      --replace-fail "/app/share/doc" "${finalAttrs.docPath}/share/doc"
    substituteInPlace src/window.blp \
      --replace-fail "/app/share/doc" "${finalAttrs.docPath}/share/doc"
    substituteInPlace src/window.js \
      --replace-fail "/app/share/doc" "${finalAttrs.docPath}/share/doc"
  '';

  postInstall = ''
    mv $out/bin/app.drey.Biblioteca $out/share/app.drey.Biblioteca/app.drey.Biblioteca
    substituteInPlace $out/bin/biblioteca \
      --replace-fail app.drey.Biblioteca $out/share/app.drey.Biblioteca/app.drey.Biblioteca
  '';

  doCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://apps.gnome.org/Biblioteca/";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    teams = [ lib.teams.gnome-circle ];
    license = lib.licenses.gpl3Only;
    description = "Documentation viewer for GNOME";
    mainProgram = "biblioteca";
  };
})
