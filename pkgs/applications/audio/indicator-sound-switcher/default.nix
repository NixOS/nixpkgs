{ python3Packages
, lib
, fetchurl
, perlPackages
, gettext
, gtk3
, gobject-introspection
, intltool, wrapGAppsHook, glib
, librsvg
, libayatana-appindicator-gtk3
, libpulseaudio
, keybinder3
, gdk-pixbuf
}:

let
  name = "indicator-sound-switcher";
  version = "2.3.6";
in
python3Packages.buildPythonApplication {
#python3Packages.buildPythonPackage {
  pname = name;
  inherit version;
  src = fetchurl {
    url = "https://github.com/yktoo/${name}/archive/v${version}.tar.gz";
    sha256 = "sha256:0xrywmppzrr4x6hhlsgrhbh516djzb04ms717vfbpycy7316arvr";
  };

  nativeBuildInputs = [
    gettext
    intltool
    wrapGAppsHook
    glib
    gdk-pixbuf
  ];

  buildInputs = [
    librsvg
  ];

  propagatedBuildInputs = [
    python3Packages.setuptools
    python3Packages.pygobject3
    gtk3
    gobject-introspection
    librsvg
    libayatana-appindicator-gtk3
    libpulseaudio
    keybinder3
  ];

  makeWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${libpulseaudio}/lib"
  ];

  meta = with lib; {
    description = "Sound input/output selector indicator for Linux";
    homepage = "https://yktoo.com/en/software/sound-switcher-indicator/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      alexnortung
    ];
    platforms = [ "x86_64-linux" ];
  };
}
