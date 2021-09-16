{ stdenv, lib, fetchFromGitHub
, python3Packages
, fehSupport ? false, feh
, imagemagickSupport ? true, imagemagick
, intltool
, gtk3
, gexiv2
, libnotify
, gobject-introspection
, hicolor-icon-theme
, librsvg
, wrapGAppsHook
, makeWrapper
}:

with python3Packages;

buildPythonApplication rec {
  pname = "variety";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "varietywalls";
    repo = "variety";
    rev = version;
    sha256 = "sha256-6dLz4KXavXwnk5GizBH46d2EHMHPjRo0WnnUuVMtI1M=";
  };

  nativeBuildInputs = [ makeWrapper intltool wrapGAppsHook ];

  buildInputs = [ distutils_extra ];

  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/variety --suffix XDG_DATA_DIRS : ${gtk3}/share/gsettings-schemas/${gtk3.name}/
  '';

  prePatch = ''
    substituteInPlace variety_lib/varietyconfig.py \
      --replace "__variety_data_directory__ = \"../data\"" "__variety_data_directory__ = \"$out/share/variety\""
    substituteInPlace data/scripts/set_wallpaper \
      --replace /bin/bash ${stdenv.shell}
    substituteInPlace data/scripts/get_wallpaper \
      --replace /bin/bash ${stdenv.shell}
  '';

  propagatedBuildInputs = [
    beautifulsoup4
    configobj
    dbus-python
    gexiv2
    gobject-introspection
    gtk3
    hicolor-icon-theme
    httplib2
    libnotify
    librsvg
    lxml
    pillow
    pycairo
    pygobject3
    requests
    setuptools
  ] ++ lib.optional fehSupport feh
    ++ lib.optional imagemagickSupport imagemagick;

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
    license = licenses.gpl3;
    maintainers = with maintainers; [ p3psi AndersonTorres zfnmxt ];
    platforms = with platforms; linux;
  };
}
