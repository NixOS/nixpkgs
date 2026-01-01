{
  lib,
  libsForQt5,
  symlinkJoin,
<<<<<<< HEAD
=======
  unwrapped ? libsForQt5.callPackage ./. { },
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  krita-plugin-gmic,
  binaryPlugins ? [
    # Default plugins provided by upstream appimage
    krita-plugin-gmic
  ],
<<<<<<< HEAD
  krita-unwrapped,
}:
symlinkJoin {
  name = lib.replaceStrings [ "-unwrapped" ] [ "" ] krita-unwrapped.name;
  inherit (krita-unwrapped)
=======
}:

symlinkJoin {
  name = lib.replaceStrings [ "-unwrapped" ] [ "" ] unwrapped.name;
  inherit (unwrapped)
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    version
    buildInputs
    nativeBuildInputs
    meta
    ;

<<<<<<< HEAD
  paths = [ krita-unwrapped ] ++ binaryPlugins;
=======
  paths = [ unwrapped ] ++ binaryPlugins;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  postBuild = ''
    wrapQtApp "$out/bin/krita" \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --set KRITA_PLUGIN_PATH "$out/lib/kritaplugins"
  '';

  passthru = {
<<<<<<< HEAD
    inherit binaryPlugins;
    unwrapped = krita-unwrapped;
=======
    inherit unwrapped binaryPlugins;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
