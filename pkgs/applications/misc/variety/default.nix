{ lib
, fetchFromGitHub
, gexiv2
, gobject-introspection
, gtk3
, hicolor-icon-theme
, intltool
, libnotify
, librsvg
, python3
, runtimeShell
, wrapGAppsHook3
, fehSupport ? false
, feh
, imagemagickSupport ? true
, imagemagick
, appindicatorSupport ? true
, libayatana-appindicator
}:

python3.pkgs.buildPythonApplication rec {
  pname = "variety";
  version = "0.8.12";

  src = fetchFromGitHub {
    owner = "varietywalls";
    repo = "variety";
    rev = "refs/tags/${version}";
    hash = "sha256-FjnhV7vzRPVDCgUNK8CHo3arKXuwe+3xH/5AxCVgeIY=";
  };

  nativeBuildInputs = [
    intltool
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    gexiv2
    gtk3
    hicolor-icon-theme
    libnotify
    librsvg
  ]
  ++ lib.optional appindicatorSupport libayatana-appindicator;

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    configobj
    dbus-python
    distutils-extra
    httplib2
    lxml
    pillow
    pycairo
    pygobject3
    requests
    setuptools
  ]
  ++ lib.optional fehSupport feh
  ++ lib.optional imagemagickSupport imagemagick;

  doCheck = false;

  # Prevent double wrapping, let the Python wrapper use the args in preFixup.
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  prePatch = ''
    substituteInPlace variety_lib/varietyconfig.py \
      --replace "__variety_data_directory__ = \"../data\"" \
                "__variety_data_directory__ = \"$out/share/variety\""
    substituteInPlace variety/VarietyWindow.py \
      --replace '[script,' '["${runtimeShell}", script,' \
      --replace 'check_output(script)' 'check_output(["${runtimeShell}", script])'
  '';

  meta = with lib; {
    homepage = "https://github.com/varietywalls/variety";
    description = "Wallpaper manager for Linux systems";
    mainProgram = "variety";
    longDescription = ''
      Variety is a wallpaper manager for Linux systems. It supports numerous
      desktops and wallpaper sources, including local files and online services:
      Flickr, Wallhaven, Unsplash, and more.

      Where supported, Variety sits as a tray icon to allow easy pausing and
      resuming. Otherwise, its desktop entry menu provides a similar set of
      options.

      Variety also includes a range of image effects, such as oil painting and
      blur, as well as options to layer quotes and a clock onto the background.
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ p3psi AndersonTorres zfnmxt ];
  };
}
