# This file contains all runtime glue: Bindings to optional runtime dependencies
# for pdfSupport, presentationSupport, and media playback.
{ lib, mkDerivation, wrapGAppsHook3, python3Packages

# qt deps
, qtbase, qtmultimedia

# optional deps
, pdfSupport ? false, mupdf  # alternatively could use ghostscript
, presentationSupport ? false, libreoffice-unwrapped
, vlcSupport ? false
, gstreamerSupport ? false, gst_all_1, gstPlugins ? (gst: [
    gst.gst-plugins-base
    gst.gst-plugins-good
    gst.gst-plugins-bad
    gst.gst-plugins-ugly
  ])

#, enableMySql ? false      # Untested. If interested, contact maintainer.
#, enablePostgreSql ? false # Untested. If interested, contact maintainer.
#, enableJenkinsApi ? false # Untested. If interested, contact maintainer.
}:

let p = gstPlugins gst_all_1;
# If gstreamer is activated but no plugins are given, it will at runtime
# create the false illusion of being usable.
in assert gstreamerSupport -> (builtins.isList p && builtins.length p > 0);

let
  # optional packages
  libreofficePath = "${libreoffice-unwrapped}/lib/libreoffice/program";

  # lib functions
  inherit (lib.lists) optional optionals;
  wrapSetVar = var: ''--set ${var} "''$${var}"'';

  # base pkg/lib
  baseLib = python3Packages.callPackage ./lib.nix { };
in mkDerivation {
  pname = baseLib.pname + lib.optionalString (pdfSupport && presentationSupport && vlcSupport && gstreamerSupport) "-full";
  inherit (baseLib) version src;

  nativeBuildInputs = [ python3Packages.wrapPython wrapGAppsHook3 ];
  buildInputs = [ qtbase ] ++ optionals gstreamerSupport
    ([ qtmultimedia.bin gst_all_1.gstreamer ] ++ gstPlugins gst_all_1);
  propagatedBuildInputs = optional pdfSupport mupdf
    ++ optional presentationSupport libreoffice-unwrapped;
  pythonPath = [ baseLib ] ++ optional vlcSupport python3Packages.python-vlc;
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
    "\${qtWrapperArgs[@]}"
  ] ++ optionals presentationSupport
    ([ "--prefix PATH : ${libreoffice-unwrapped}/bin" ]
      ++ map wrapSetVar [ "URE_BOOTSTRAP" "UNO_PATH" ]);

  installPhase = ''
    install -D openlp.py $out/bin/openlp
  '';

  preFixup = ''
    wrapPythonPrograms
  '';

  meta = baseLib.meta // {
    hydraPlatforms = [ ]; # this is only the wrapper; baseLib gets built
  };

  passthru = {
    inherit baseLib;
  };
}
