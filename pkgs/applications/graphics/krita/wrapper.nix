{ lib
, libsForQt5
, symlinkJoin
, unwrapped ? libsForQt5.callPackage ./. { }
, binaryPlugins ? [ ]
}:

symlinkJoin {
  name = lib.replaceStrings [ "-unwrapped" ] [ "" ] unwrapped.name;
  inherit (unwrapped) version buildInputs nativeBuildInputs meta;

  paths = [ unwrapped ] ++ binaryPlugins;

  postBuild = ''
    wrapQtApp "$out/bin/krita" \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --set KRITA_PLUGIN_PATH "$out/lib/kritaplugins"
  '';

  passthru = {
    inherit unwrapped binaryPlugins;
  };
}
