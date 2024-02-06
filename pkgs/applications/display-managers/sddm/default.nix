{
  callPackage,
  runCommand,
  wrapQtAppsHook,
  unwrapped ? callPackage ./unwrapped.nix {},
  extraPackages ? [],
}:
runCommand "sddm-wrapped" {
  inherit (unwrapped) version;

  buildInputs = unwrapped.buildInputs ++ extraPackages;
  nativeBuildInputs = [ wrapQtAppsHook ];

  passthru = {
    inherit unwrapped;
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
    makeQtWrapper ${unwrapped}/$i $out/$i --set SDDM_GREETER $out/bin/sddm-greeter
  done
''
