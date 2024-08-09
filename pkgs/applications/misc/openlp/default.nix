# This file contains all runtime glue: Bindings to optional runtime dependencies
# for pdfSupport, presentationSupport, and media playback.
{ lib, mkDerivation, wrapGAppsHook3, python3Packages

# qt deps
, qtbase

# optional deps
, pdfSupport ? false
, presentationSupport ? false, libreoffice-unwrapped
, vlcSupport ? false
#, enableMySql ? false      # Untested. If interested, contact maintainer.
#, enablePostgreSql ? false # Untested. If interested, contact maintainer.
#, enableJenkinsApi ? false # Untested. If interested, contact maintainer.
}:

let
  # optional packages
  libreofficePath = "${libreoffice-unwrapped}/lib/libreoffice/program";

  # lib functions
  inherit (lib.lists) optional optionals;
  wrapSetVar = var: ''--set ${var} "''$${var}"'';

  pythonPackages = python3Packages.overrideScope (final: prev: {
    pyqt5 = prev.pyqt5.override { withMultimedia = true; };
    pyqt5-multimedia = final.pyqt5;
  });

  # base pkg/lib
  baseLib = pythonPackages.callPackage ./lib.nix { };
in mkDerivation {
  pname = baseLib.pname + lib.optionalString (pdfSupport && presentationSupport && vlcSupport) "-full";
  inherit (baseLib) version src meta;

  nativeBuildInputs = [ python3Packages.wrapPython wrapGAppsHook3 ];
  buildInputs = [ qtbase ];
  propagatedBuildInputs = optional pdfSupport pythonPackages.pymupdf
    ++ optional presentationSupport libreoffice-unwrapped;
  pythonPath = [ baseLib ] ++ optional vlcSupport pythonPackages.python-vlc;
    # ++ optional enableMySql mysql-connector  # Untested. If interested, contact maintainer.
    # ++ optional enablePostgreSql psycopg2    # Untested. If interested, contact maintainer.
    # ++ optional enableJenkinsApi jenkinsapi  # Untested. If interested, contact maintainer.

  PYTHONPATH = libreofficePath;
  URE_BOOTSTRAP = "vnd.sun.star.pathname:${libreofficePath}/fundamentalrc";
  UNO_PATH = libreofficePath;
  LD_LIBRARY_PATH = libreofficePath;
  JAVA_HOME = "${libreoffice-unwrapped.jdk.home}";

  dontWrapQtApps = true;
  dontWrapGApps = true;

  # defined in gappsWrapperHook
  wrapPrefixVariables = optionals presentationSupport
    [ "PYTHONPATH" "LD_LIBRARY_PATH" "JAVA_HOME" ];
  makeWrapperArgs = [
    "\${gappsWrapperArgs[@]}"
    # Force the app to use QT_PLUGIN_PATH values from wrapper
    "--unset QT_PLUGIN_PATH"
    "\${qtWrapperArgs[@]}"
    #--set QTWEBENGINE_RESOURCES_PATH "${qtwebengine}/resources"
  ] ++ optionals presentationSupport
    ([ "--prefix PATH : ${libreoffice-unwrapped}/bin" ]
      ++ map wrapSetVar [ "URE_BOOTSTRAP" "UNO_PATH" ]);

  installPhase = ''
    install -D run_openlp.py $out/bin/openlp
  '';

  preFixup = ''
    wrapPythonPrograms
  '';

  passthru = {
    inherit baseLib;
  };
}
