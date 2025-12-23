{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  libpeas2,
  json-glib,
  libsoup_3,
  glib,
  clapper-unwrapped,
  gst_all_1,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clapper-enhancers";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "Rafostar";
    repo = "clapper-enhancers";
    tag = finalAttrs.version;
    hash = "sha256-uj0ZZrS2Y896EDWeBsU3Q3S2kFdEg5FQkBOcI97FFWc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    python3Packages.python
    python3Packages.wrapPython
  ];

  buildInputs = [
    libpeas2
    json-glib
    libsoup_3
    glib
    clapper-unwrapped
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
  ];

  pythonPath = with python3Packages; [
    yt-dlp
  ];

  postFixup = ''
    buildPythonPath "$out $pythonPath"
    for yt_plugin in $out/lib/clapper-enhancers/plugins/yt-dlp/*.py; do
      patchPythonScript $yt_plugin
    done
  '';

  mesonFlags = [ "-Denhancersdir=${placeholder "out"}/${finalAttrs.passthru.pluginPath}" ];

  passthru.pluginPath = "lib/clapper-enhancers/plugins";

  meta = {
    description = "Plugins enhancing Clapper library capabilities";
    homepage = "https://github.com/Rafostar/clapper-enhancers";
    license = lib.licenses.lgpl21Only;
    inherit (clapper-unwrapped.meta) maintainers platforms;
  };
})
