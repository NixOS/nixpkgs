{
  stdenv,
  lib,
  fetchFromGitHub,
  appstream-glib,
  desktop-file-utils,
  gdk-pixbuf,
  gettext,
  gjs,
  glib,
  glib-networking,
  gobject-introspection,
  gsettings-desktop-schemas,
  gtk4,
  hicolor-icon-theme,
  meson,
  ninja,
  pkg-config,
  python3,
  webkitgtk,
  wrapGAppsHook,
}:
stdenv.mkDerivation rec {
  pname = "tangram";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "sonnyp";
    repo = "Tangram";
    rev = "v${version}";
    sha256 = "sha256-0KSmqDLp7+mmrzTlil8iXUdHmHUz91AoCcbc6YcHKbI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gettext
    gobject-introspection
    hicolor-icon-theme
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    gdk-pixbuf
    gjs
    glib
    glib-networking
    gsettings-desktop-schemas
    gtk4
    webkitgtk
  ];

  dontPatchShebangs = true;
  dontWrapGApps = true;

  # Fixes https://github.com/NixOS/nixpkgs/issues/31168
  postPatch = ''
    chmod +x build-aux/meson/postinstall.py
    patchShebangs build-aux/meson/postinstall.py
    substituteInPlace src/re.sonny.Tangram.in --replace "#!/usr/bin/env -S gjs -m" "#!/usr/bin/env -S ${gjs}/bin/gjs -m"
  '';

  postFixup = ''
    for file in $out/bin/re.sonny.Tangram; do
      sed -e $"2iimports.package._findEffectiveEntryPointName = () => \'$(basename $file)\' " \
         -i $file
      wrapGApp "$file"
     done
  '';

  meta = with lib; {
    description = "Run web apps on your desktop";
    homepage = "https://github.com/sonnyp/Tangram";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [austinbutler];
  };
}
