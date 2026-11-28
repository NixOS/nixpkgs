{
  makeSetupHook,
  lib,
  juce,
  writableTmpDirAsHomeHook,
  alsa-lib,
  curl,
  gtk3,
  libGL,
  libx11,
  libxcursor,
  libxext,
  libxinerama,
  libxrandr,
  pkg-config,
  webkitgtk_4_1,
}:
makeSetupHook {
  name = "projucer-hook";

  propagatedBuildInputs = [
    juce
    writableTmpDirAsHomeHook
    pkg-config
  ];

  depsTargetTargetPropagated = [
    alsa-lib
    curl
    gtk3
    libGL
    libx11
    libxcursor
    libxext
    libxinerama
    libxrandr
    webkitgtk_4_1
  ];

  substitutions.juce = juce.src;

  meta = {
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
  };
} ./projucer-hook.sh
