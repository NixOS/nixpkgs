{ lib
, stdenv
, mkDerivationWith
, fetchFromGitHub
, doxygen
, gtk3
, libopenshot
, python3
, qtbase
, qtsvg
, wrapGAppsHook
}:

let
  pname = "openshot-qt";
  version = "3.1.1";
  src = fetchFromGitHub {
    owner = "OpenShot";
    repo = "openshot-qt";
    rev = "v${version}";
    hash = "sha256-kEz1APBitWLlnIbyloYMsqNrwC9RqU04kyyWzm5klYc=";
  };
in
mkDerivationWith python3.pkgs.buildPythonApplication {
  inherit pname version src;

  outputs = [ "out" ]; # "lib" can't be split

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
    sip4
  ];

  strictDeps = true;

  preConfigure = ''
    # the builder tries to create caching directories during install
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
    --suffix QT_PLUGIN_PATH : "${lib.getBin qtsvg}/${qtbase.qtPluginPrefix}" \
  '' + ''
    "''${gappsWrapperArgs[@]}" \
    "''${qtWrapperArgs[@]}"
  '';

  passthru = {
    inherit libopenshot;
    inherit (libopenshot) libopenshot-audio;
  };

  meta = {
    homepage = "http://openshot.org/";
    description = "Free, open-source video editor";
    longDescription = ''
      OpenShot Video Editor is a free, open-source video editor for Linux.
      OpenShot can take your videos, photos, and music files and help you create
      the film you have always dreamed of. Easily add sub-titles, transitions,
      and effects, and then export your film to DVD, YouTube, Vimeo, Xbox 360,
      and many other common formats.
    '';
    license = with lib.licenses; [ gpl3Plus ];
    mainProgram = "openshot-qt";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
}
