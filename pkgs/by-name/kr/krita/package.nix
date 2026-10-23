{
  symlinkJoin,
  krita-plugin-gmic,
  binaryPlugins ? [
    # Default plugins provided by upstream appimage
    krita-plugin-gmic
  ],
  krita-unwrapped,
  wrapGAppsHook3,
}:
symlinkJoin {
  pname = "krita";
  inherit (krita-unwrapped)
    version
    buildInputs
    meta
    ;

  nativeBuildInputs = krita-unwrapped.nativeBuildInputs ++ [
    wrapGAppsHook3
  ];

  paths = [ krita-unwrapped ] ++ binaryPlugins;

  postBuild = ''
    gappsWrapperArgsHook
    wrapQtApp "$out/bin/krita" \
      "''${gappsWrapperArgs[@]}" \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --set KRITA_PLUGIN_PATH "$out/lib/kritaplugins"
  '';

  passthru = {
    inherit binaryPlugins;
    unwrapped = krita-unwrapped;
  };
}
