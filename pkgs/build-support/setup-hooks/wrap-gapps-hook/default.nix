{ stdenv
, lib
, makeSetupHook
, makeWrapper
, gtk3
, librsvg
, dconf
}:

makeSetupHook {
  deps = lib.optional (!stdenv.isDarwin) dconf.lib ++ [
    gtk3
    librsvg
    makeWrapper
  ];
} ./wrap-gapps-hook.sh
