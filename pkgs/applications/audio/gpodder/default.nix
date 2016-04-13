{ stdenv, fetchurl, buildPythonApplication, pythonPackages, mygpoclient, intltool
, ipodSupport ? true, libgpod
, gnome3
}:

buildPythonApplication rec {
  name = "gpodder-${version}";
  namePrefix = "";

  version = "3.9.0";

  src = fetchurl {
    url = "http://gpodder.org/src/${name}.tar.gz";
    sha256 = "1ik954idi0ldnw0wrv7mm71smyb6x66332jxcaf1dxsl12ccm44l";
  };

  postPatch = with stdenv.lib; ''
    sed -i -re 's,^( *gpodder_dir *= *).*,\1"'"$out"'",' bin/gpodder

    makeWrapperArgs="--suffix XDG_DATA_DIRS : '${concatStringsSep ":" [
      "${gnome3.gnome_themes_standard}/share"
      "$XDG_ICON_DIRS"
      "$GSETTINGS_SCHEMAS_PATH"
    ]}'"
  '';

  buildInputs = [
    intltool pythonPackages.coverage pythonPackages.minimock
    gnome3.gnome_themes_standard gnome3.defaultIconTheme
    gnome3.gsettings_desktop_schemas
  ];

  propagatedBuildInputs = with pythonPackages; [
    feedparser dbus mygpoclient sqlite3 pygtk eyeD3
  ] ++ stdenv.lib.optional ipodSupport libgpod;

  checkPhase = ''
    LC_ALL=C python -m gpodder.unittests
  '';

  meta = {
    description = "A podcatcher written in python";
    longDescription = ''
      gPodder downloads and manages free audio and video content (podcasts)
      for you. Listen directly on your computer or on your mobile devices.
    '';
    homepage = "http://gpodder.org/";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = [ stdenv.lib.maintainers.skeidel ];
  };
}
