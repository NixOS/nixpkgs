{ lib
, fetchFromGitHub
, runtimeShell
, gobject-introspection
, intltool
, wrapGAppsHook
, gtk3
, python3
, python3Packages
, cameraSupport ? true
, gnome
, clutter-gtk
, gst_all_1
}:
let
  pluginPath = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [ gst_all_1.gst-plugins-good gst_all_1.gst-plugins-bad ];
in
python3Packages.buildPythonApplication rec {
  pname = "mugshot";
  version = "0.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bluesabre";
    repo = "mugshot";
    rev = "mugshot-${version}";
    sha256 = "sha256-RjD7IUBHqmB4DJ1abATYDPZLIHVwiXblWvWcq6xjhQk=";
  };

  nativeBuildInputs = [
    gobject-introspection
    intltool
    python3Packages.distutils-extra
    python3Packages.setuptools
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    python3
    python3Packages.pexpect
    python3Packages.pycairo
    python3Packages.pygobject3
  ];

  propagatedBuildInputs = lib.optional cameraSupport [
    clutter-gtk
    gnome.cheese
    gst_all_1.gstreamer
  ];

  postPatch = ''
    sed -i "/^        if self.root/i\\        self.prefix = \"$out\"" setup.py
  '';

  preFixup = ''
    gappsWrapperArgs+=(
    --prefix PYTHONPATH : "$PYTHONPATH:$out/${python3.sitePackages}"
    --prefix GST_PRESET_PATH : "${gst_all_1.gst-plugins-good}/share/gstreamer-1.0/presets"
    --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "${pluginPath}"
    )
  '';

  postInstall = ''
    glib-compile-schemas "$out"/share/glib-2.0/schemas
  '';

  meta = with lib; {
    description = "A lightweight user configuration utility for Linux";
    homepage = "https://github.com/bluesabre/mugshot";
    maintainers = with maintainers; [ joshuafern ];
    license = licenses.gpl3Plus;
    mainProgram = "mugshot";
    platforms = platforms.linux;
  };
}
