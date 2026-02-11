{
  lib,
  libsForQt5,
  symlinkJoin,
  krita-plugin-gmic,
  binaryPlugins ? [
    # Default plugins provided by upstream appimage
    krita-plugin-gmic
  ],
  krita-unwrapped,
}:
symlinkJoin {
  pname = "krita";
  inherit (krita-unwrapped)
    version
    buildInputs
    nativeBuildInputs
    meta
    ;

  paths = [ krita-unwrapped ] ++ binaryPlugins;

  postBuild = ''
    wrapQtApp "$out/bin/krita" \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --set KRITA_PLUGIN_PATH "$out/lib/kritaplugins"
  '';

  passthru = {
    inherit binaryPlugins;
    unwrapped = krita-unwrapped;
  };
}
