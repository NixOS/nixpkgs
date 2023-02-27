{ stdenv
, lib
, fetchFromGitHub
, appstream-glib
, desktop-file-utils
, gdk-pixbuf
, gettext
, gjs
, glib
, glib-networking
, gobject-introspection
, gsettings-desktop-schemas
, gtk4
, libadwaita
, gst_all_1
, hicolor-icon-theme
, meson
, ninja
, pkg-config
, python3
, webkitgtk_5_0
, blueprint-compiler
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "tangram";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "sonnyp";
    repo = "Tangram";
    rev = "v${version}";
    hash = "sha256-ocHE8IztiNm9A1hbzzHXstWpPaOau/IrQ44ccxbsGb0=";
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
    blueprint-compiler
    wrapGAppsHook
  ];

  buildInputs = [
    gdk-pixbuf
    gjs
    glib
    glib-networking
    gsettings-desktop-schemas
    gtk4
    libadwaita
    webkitgtk_5_0
  ] ++ (with gst_all_1; [
    gstreamer
    gst-libav
    gst-plugins-base
    (gst-plugins-good.override { gtkSupport = true; })
    gst-plugins-bad
  ]);

  dontPatchShebangs = true;

  postPatch = ''
    substituteInPlace src/meson.build --replace "/app/bin/blueprint-compiler" "blueprint-compiler"
    substituteInPlace {src/,}re.sonny.Tangram troll/gjspack/bin/gjspack \
      --replace "#!/usr/bin/env -S gjs -m" "#!${gjs}/bin/gjs -m"
  '';

  # https://github.com/NixOS/nixpkgs/issues/31168#issuecomment-341793501
  preFixup = ''
    sed -e '2iimports.package._findEffectiveEntryPointName = () => "re.sonny.Tangram"' \
      -i $out/bin/re.sonny.Tangram
  '';

  meta = with lib; {
    description = "Run web apps on your desktop";
    homepage = "https://github.com/sonnyp/Tangram";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ austinbutler chuangzhu ];
  };
}
