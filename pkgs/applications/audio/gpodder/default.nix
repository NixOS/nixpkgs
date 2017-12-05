{ stdenv, fetchurl, fetchpatch, python2Packages, mygpoclient, intltool
, ipodSupport ? false, libgpod
, gnome3
}:

python2Packages.buildPythonApplication rec {
  name = "gpodder-${version}";

  version = "3.9.3";

  src = fetchurl {
    url = "http://gpodder.org/src/${name}.tar.gz";
    sha256 = "1s83m90dic2zphwwv6wrvqx950y12v5sakm7q5nj5bnh5k9l2hgl";
  };

  patches = [
    (fetchpatch {
     sha256 = "1xkl1wnp46546jrzsnb9p0yj23776byg3nvsqwbblhqbsfipl48w";
     name = "Fix-soundcloud-feeds.patch";
     url = "https://github.com/gpodder/gpodder/commit/e7f34ad090cd276d75c0cd8d92ed97243d75db38.patch";
    })
    (fetchpatch {
     sha256 = "1jlldbinlxis1pi9p2lyczgbcv8nmdj66fxll6ph0klln0w8gvg4";
     name = "use-https-urls-for-soundcloud.patch";
     url = "https://github.com/gpodder/gpodder/commit/ef915dd3b6828174bf4f6f0911da410d9aca1b67.patch";
    })
    (fetchpatch {
     sha256 = "1l37ihzk7gfqcl5nnphv0sv80psm6fsg4qkxn6abc6v476axyj9b";
     name = "updates-soundcloud-support-to-recognize-https";
     url = "https://github.com/gpodder/gpodder/commit/5c1507671d93096ad0118f908c20dd1f182a72e0.patch";
    })
  ];

  postPatch = with stdenv.lib; ''
    sed -i -re 's,^( *gpodder_dir *= *).*,\1"'"$out"'",' bin/gpodder

    makeWrapperArgs="--suffix XDG_DATA_DIRS : '${concatStringsSep ":" [
      "${gnome3.gnome_themes_standard}/share"
      "$XDG_ICON_DIRS"
      "$GSETTINGS_SCHEMAS_PATH"
    ]}'"
  '';

  buildInputs = [
    intltool python2Packages.coverage python2Packages.minimock
    gnome3.gnome_themes_standard gnome3.defaultIconTheme
    gnome3.gsettings_desktop_schemas
  ];

  propagatedBuildInputs = with python2Packages; [
    feedparser dbus-python mygpoclient pygtk eyeD3 podcastparser html5lib
  ] ++ stdenv.lib.optional ipodSupport libgpod;

  checkPhase = ''
    LC_ALL=C python -m gpodder.unittests
  '';

  meta = with stdenv.lib; {
    description = "A podcatcher written in python";
    longDescription = ''
      gPodder downloads and manages free audio and video content (podcasts)
      for you. Listen directly on your computer or on your mobile devices.
    '';
    homepage = http://gpodder.org/;
    license = licenses.gpl3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ skeidel mic92 ];
  };
}
