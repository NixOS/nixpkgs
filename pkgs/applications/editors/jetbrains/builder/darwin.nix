# Darwin-specific base builder.

{
  lib,
  stdenvNoCC,
  undmg,

  excludeDrvArgNames,
  ...
}:

lib.extendMkDerivation {
  inherit excludeDrvArgNames;

  constructDrv = stdenvNoCC.mkDerivation;

  extendDrvArgs =
    finalAttrs:
    {
      product,
      productShort ? product,

      nativeBuildInputs ? [ ],
      meta ? { },
      ...
    }:

    let
      loname = lib.toLower productShort;
    in
    {
      desktopName = product;

      dontFixup = true;

      installPhase = ''
        runHook preInstall
        APP_DIR="$out/Applications/${product}.app"
        mkdir -p "$APP_DIR"
        cp -Tr *.app "$APP_DIR"
        mkdir -p "$out/bin"
        cat << EOF > "$out/bin/${loname}"
        #!${stdenvNoCC.shell}
        open -na '$APP_DIR' --args "\$@"
        EOF
        chmod +x "$out/bin/${loname}"
        runHook postInstall
      '';

      nativeBuildInputs = nativeBuildInputs ++ [ undmg ];

      sourceRoot = ".";

      meta = meta // {
        mainProgram = loname;
      };
    };
}
