{
  fehSupport ? false, feh
, imagemagickSupport ? true, imagemagick
, stdenv
, lib
, python37Packages
, fetchFromGitHub
, intltool
, gtk3
, gexiv2
, libnotify
, wrapGAppsHook
, gobject-introspection
, hicolor-icon-theme
, librsvg
}:

with python37Packages;

buildPythonApplication rec {
  pname = "variety";
  version = "0.7.2-96-g3afe3ab";

  src = fetchFromGitHub {
    owner = "varietywalls";
    repo = "variety";
    rev = "3afe3abf725e5db2aec0db575a17c9907ab20de1";
    sha256 = "10vw0202dwrwi497nsbq077v4qd3qn5b8cmkfcsgbvvjwlz7ldm5";
  };

  nativeBuildInputs = [ intltool wrapGAppsHook ];

  buildInputs = [ distutils_extra ];

  doCheck = false;

  prePatch = ''
    substituteInPlace variety_lib/varietyconfig.py \
      --replace "__variety_data_directory__ = \"../data\"" "__variety_data_directory__ = \"$out/share/variety\""
    substituteInPlace data/scripts/set_wallpaper \
      --replace /bin/bash ${stdenv.shell}
    substituteInPlace data/scripts/get_wallpaper \
      --replace /bin/bash ${stdenv.shell}
  '';

  propagatedBuildInputs =
       [ gtk3
         gexiv2
         libnotify
         beautifulsoup4
         lxml
         pycairo
         pygobject3
         configobj
         pillow
         setuptools
         requests
         httplib2
         dbus-python
         gobject-introspection
         hicolor-icon-theme
         librsvg
       ]
    ++ lib.optional fehSupport feh
    ++ lib.optional imagemagickSupport imagemagick;

  meta = with lib; {
    description = "A wallpaper manager for Linux systems. It supports numerous desktops and wallpaper sources, including local files and online services: Flickr, Wallhaven, Unsplash, and more";
    homepage = https://github.com/varietywalls/variety;
    license = licenses.gpl3;
    maintainers = [ maintainers.zfnmxt ];
  };
}
