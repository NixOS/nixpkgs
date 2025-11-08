{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  glib,
  gjs,
  ninja,
  gtk4,
  gsettings-desktop-schemas,
  wrapGAppsHook4,
  desktop-file-utils,
  gobject-introspection,
  glib-networking,
  pkg-config,
  libadwaita,
  appstream,
  blueprint-compiler,
  gettext,
  libportal-gtk4,
  languagetool,
  libsoup_3,
  openjdk,
  xdg-desktop-portal,
  dbus,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eloquent";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "sonnyp";
    repo = "Eloquent";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-+XAiRB5dRq2A2XP9ZdmIfxLjhCXb72TXRxnLnOprNT4=";
  };

  nativeBuildInputs = [
    appstream
    blueprint-compiler
    desktop-file-utils
    gjs
    gobject-introspection
    libportal-gtk4
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    dbus
    gettext
    gjs
    glib
    glib-networking
    gsettings-desktop-schemas
    gtk4
    libadwaita
    libportal-gtk4
    libsoup_3
    xdg-desktop-portal
  ];

  postPatch = ''
    substituteInPlace troll/gjspack/bin/gjspack \
      --replace-fail "/usr/bin/env -S gjs" "${gjs}/bin/gjs"

    substituteInPlace src/languagetool.js \
      --replace-fail "/app/LanguageTool/languagetool-server.jar" "${languagetool}/share/languagetool-server.jar" \
      --replace-fail "--config" "" \
      --replace-fail "/app/share/server.properties" ""

    sed -i "1 a imports.package._findEffectiveEntryPointName = () => 're.sonny.Eloquent';" src/bin.js
    patchShebangs .
  '';

  strictDeps = true;

  preFixup = ''
    gappsWrapperArgs+=(
      --set JAVA_HOME ${openjdk}
      --prefix PATH : ${openjdk}/bin
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Proofreading software for English, Spanish, French, German, and more than 20 other languages";
    homepage = "https://github.com/sonnyp/eloquent";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ thtrf ];
    mainProgram = "re.sonny.Eloquent";
    platforms = lib.platforms.linux;
  };
})
