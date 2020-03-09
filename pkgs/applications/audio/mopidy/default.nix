{ stdenv, fetchFromGitHub, python3Packages, wrapGAppsHook
, gst_all_1, glib-networking, gobject-introspection
}:

python3Packages.buildPythonApplication rec {
  pname = "mopidy";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy";
    rev = "v${version}";
    sha256 = "0fpjprjw143ixak68iwxjpscdjgyb7rsr1cxj7fsdrw6hc83nq4z";
  };

  nativeBuildInputs = [ wrapGAppsHook ];

  buildInputs = with gst_all_1; [
    gst-plugins-base gst-plugins-good gst-plugins-ugly gst-plugins-bad
    glib-networking gobject-introspection
  ];

  propagatedBuildInputs = with python3Packages; [
    gst-python pygobject3 pykka tornado_4 requests setuptools
  ] ++ stdenv.lib.optional (!stdenv.isDarwin) dbus-python;

  # There are no tests
  doCheck = false;

  preFixup = ''
    gappsWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH : "$GST_PLUGIN_SYSTEM_PATH")
  '';

  meta = with stdenv.lib; {
    homepage = https://www.mopidy.com/;
    description = ''
      An extensible music server that plays music from local disk, Spotify,
      SoundCloud, Google Play Music, and more
    '';
    license = licenses.asl20;
    maintainers = [ maintainers.fpletz ];
    hydraPlatforms = [];
  };
}
