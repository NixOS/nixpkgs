{ stdenv, lib, fetchFromGitHub, appstream-glib, desktop-file-utils, gdk-pixbuf
, gettext, gjs, glib, gobject-introspection, gsettings-desktop-schemas, gtk3
, hicolor-icon-theme, meson, ninja, pkg-config, python3, webkitgtk, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "tangram";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "sonnyp";
    repo = "Tangram";
    rev = "v${version}";
    sha256 = "sha256-WI0H3bforQ6Jc/+TWFT1zUs4KRtWwvXY2/va+Fnd+iU=";
    fetchSubmodules = true;
  };

  buildInputs = [ gdk-pixbuf gjs glib gsettings-desktop-schemas gtk3 webkitgtk ];

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

  dontWrapGApps = true;

  # Fixes https://github.com/NixOS/nixpkgs/issues/31168
  postPatch = ''
    chmod +x build-aux/meson/postinstall.py
    patchShebangs build-aux/meson/postinstall.py
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
    maintainers = with maintainers; [ austinbutler ];
  };
}
