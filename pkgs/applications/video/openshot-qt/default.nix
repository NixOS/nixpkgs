{ lib
, stdenv
, mkDerivationWith
, fetchFromGitHub
, fetchpatch
, doxygen
, gtk3
, libopenshot
, python3
, qtsvg
, wrapGAppsHook
}:

mkDerivationWith python3.pkgs.buildPythonApplication rec {
  pname = "openshot-qt";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "OpenShot";
    repo = "openshot-qt";
    rev = "v${version}";
    hash = "sha256-h4R2txi038m6tzdKYiXIB8CiqWt2MFFRNerp1CFP5as=";
  };

  nativeBuildInputs = [
    doxygen
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
  ];

  propagatedBuildInputs = with python3.pkgs; [
    httplib2
    libopenshot
    pyqtwebengine
    pyzmq
    requests
    sip_4
  ];

  preConfigure = ''
    # tries to create caching directories during install
    export HOME=$(mktemp -d)
  '';

  doCheck = false;

  dontWrapGApps = true;
  dontWrapQtApps = true;

  postFixup = ''
    wrapProgram $out/bin/openshot-qt \
  ''
  # Fix toolbar icons on Darwin
  + lib.optionalString stdenv.isDarwin ''
    --suffix QT_PLUGIN_PATH : "${lib.getBin qtsvg}/lib/qt-5.12.7/plugins" \
  '' + ''
    "''${gappsWrapperArgs[@]}" \
    "''${qtWrapperArgs[@]}"
  '';

  passthru = {
    inherit libopenshot;
    inherit (libopenshot) libopenshot-audio;
  };

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
}
