{ lib
, stdenv
, mkDerivationWith
, fetchFromGitHub
, doxygen
, gtk3
, libopenshot
, python3Packages
, qtsvg
, wrapGAppsHook
}:

mkDerivationWith python3Packages.buildPythonApplication rec {
  pname = "openshot-qt";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "OpenShot";
    repo = "openshot-qt";
    rev = "v${version}";
    sha256 = "0pa8iwl217503bjlqg2zlrw5lxyq5hvxrf5apxrh3843hj1w1myv";
  };

  nativeBuildInputs = [
    doxygen
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
  ];

  propagatedBuildInputs = with python3Packages; [
    httplib2
    libopenshot
    pyqt5_with_qtwebkit
    pyzmq
    requests
    sip_4
  ];

  dontWrapGApps = true;
  dontWrapQtApps = true;

  preConfigure = ''
    # tries to create caching directories during install
    export HOME=$(mktemp -d)
  '';

  postFixup = ''
    wrapProgram $out/bin/openshot-qt \
  ''
  # Fix toolbar icons on Darwin
  + lib.optionalString stdenv.isDarwin ''
      --suffix QT_PLUGIN_PATH : "${lib.getBin qtsvg}/lib/qt-5.12.7/plugins" \
  ''
  + ''
      "''${gappsWrapperArgs[@]}" \
      "''${qtWrapperArgs[@]}"
  '';

  doCheck = false;

  meta = with lib; {
    homepage = "http://openshot.org/";
    description = "Free, open-source video editor";
    longDescription = ''
      OpenShot Video Editor is a free, open-source video editor for Linux.
      OpenShot can take your videos, photos, and music files and help you
      create the film you have always dreamed of. Easily add sub-titles,
      transitions, and effects, and then export your film to DVD, YouTube,
      Vimeo, Xbox 360, and many other common formats.
    '';
    license = with licenses; gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; unix;
  };

  passthru = {
    inherit libopenshot;
    inherit (libopenshot) libopenshot-audio;
  };
}
