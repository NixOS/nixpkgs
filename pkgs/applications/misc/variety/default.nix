{ lib
, stdenv
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
, wrapGAppsHook
, fehSupport ? false, feh
, imagemagickSupport ? true, imagemagick
}:

python3.pkgs.buildPythonApplication rec {
  pname = "variety";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "varietywalls";
    repo = "variety";
    rev = version;
    sha256 = "sha256-6dLz4KXavXwnk5GizBH46d2EHMHPjRo0WnnUuVMtI1M=";
  };

  nativeBuildInputs = [
    intltool
    wrapGAppsHook
  ];

  propagatedBuildInputs = [
   gexiv2
   gobject-introspection
   gtk3
   hicolor-icon-theme
   libnotify
   librsvg
  ]
  ++ (with python3.pkgs; [
    beautifulsoup4
    configobj
    dbus-python
    distutils_extra
    httplib2
    lxml
    pillow
    pycairo
    pygobject3
    requests
    setuptools
  ])
  ++ lib.optional fehSupport feh
  ++ lib.optional imagemagickSupport imagemagick;

  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/variety --suffix XDG_DATA_DIRS : ${gtk3}/share/gsettings-schemas/${gtk3.name}/
  '';

  prePatch = ''
    substituteInPlace variety_lib/varietyconfig.py \
      --replace "__variety_data_directory__ = \"../data\"" \
                "__variety_data_directory__ = \"$out/share/variety\""
    substituteInPlace data/scripts/set_wallpaper \
      --replace /bin/bash ${runtimeShell}
    substituteInPlace data/scripts/get_wallpaper \
      --replace /bin/bash ${runtimeShell}
  '';

  meta = with lib; {
    homepage = "https://github.com/varietywalls/variety";
    description = "A wallpaper manager for Linux systems";
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
