{
  lib,
  callPackage,
  runCommand,
  qtwayland,
  wrapQtAppsHook,
  unwrapped ? callPackage ./unwrapped.nix {},
  withWayland ? false,
  extraPackages ? [],
}:
runCommand "sddm-wrapped" {
  inherit (unwrapped) version;

  buildInputs = unwrapped.buildInputs ++ extraPackages ++ lib.optional withWayland qtwayland;
  nativeBuildInputs = [ wrapQtAppsHook ];

  passthru = {
    inherit unwrapped;
    inherit (unwrapped.passthru) tests;
  };

  meta = unwrapped.meta;
} ''
  mkdir -p $out/bin

  cd ${unwrapped}

  for i in *; do
    if [ "$i" == "bin" ]; then
      continue
    fi
    ln -s ${unwrapped}/$i $out/$i
  done

  for i in bin/*; do
    makeQtWrapper ${unwrapped}/$i $out/$i --set SDDM_GREETER_DIR $out/bin
  done
''
