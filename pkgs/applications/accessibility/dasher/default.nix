{ stdenv, lib, fetchFromGitHub, fetchpatch
, autoreconfHook, pkg-config, wrapGAppsHook
, glib, gtk3, expat, gnome-doc-utils, which
, at-spi2-core, dbus
, libxslt, libxml2
, speechSupport ? true, speechd ? null
}:

assert speechSupport -> speechd != null;

stdenv.mkDerivation {
  pname = "dasher";
  version = "2018-04-03";

  src = fetchFromGitHub {
    owner = "dasher-project";
    repo = "dasher";
    rev = "9ab12462e51d17a38c0ddc7f7ffe1cb5fe83b627";
    sha256 = "1r9xn966nx3pv2bidd6i3pxmprvlw6insnsb38zabmac609h9d9s";
  };

  patches = [
    # https://github.com/dasher-project/dasher/issues/180
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/dasher/commit/5eed251f9bb0bae10e2efe177e1054346c7347d1.patch";
      sha256 = "sha256-wMmU1AY0ZL3u3k1IfUzg6ZyGdpNd7A8sWf8levf7rqY=";
    })
  ];

  prePatch = ''
    # tries to invoke git for something, probably fetching the ref
    echo "true" > build-aux/mkversion
  '';

  configureFlags = lib.optional (!speechSupport) "--disable-speech";

  nativeBuildInputs = [
    autoreconfHook
    wrapGAppsHook
    pkg-config
    # doc generation
    gnome-doc-utils
    which
    libxslt libxml2
  ];

  buildInputs = [
    glib
    gtk3
    expat
    # at-spi2 needs dbus to be recognized by pkg-config
    at-spi2-core dbus
  ] ++ lib.optional speechSupport speechd;

  meta = {
    homepage = "http://www.inference.org.uk/dasher/";
    description = "Information-efficient text-entry interface, driven by natural continuous pointing gestures";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.Profpatsch ];
    platforms = lib.platforms.all;
  };

}
