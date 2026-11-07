{
  lib,
  stdenvNoCC,
}:

lib.extendMkDerivation {
  constructDrv = stdenvNoCC.mkDerivation;

  excludeDrvArgNames = [ "variants" ];

  extendDrvArgs =
    finalAttrs:
    {
      variants,
      meta ? { },
      steamDisplayName ? finalAttrs.pname,
      ...
    }@args:
    let
      name = args.pname or "mkProtonBinDerivation";

      # Ensure the structure of variants
      checkVariant =
        system:
        let
          variant = variants.${system};
        in
        lib.assertMsg (lib.elem system lib.platforms.all) "${name}: `${system}` in `variants` is not a known system"
        && lib.assertMsg (
          variant ? src && variant ? toolName
        ) "${name}: `variants.${system}` must set `src` and `toolName`"
        && lib.assertMsg (
          removeAttrs variant [
            "src"
            "toolName"
          ] == { }
        ) "${name}: `variants.${system}` has unknown attributes, only `src` and `toolName` are allowed";
    in
    assert lib.all checkVariant (lib.attrNames variants);
    {
      inherit steamDisplayName;

      inherit (variants.${stdenvNoCC.hostPlatform.system}) src toolName;

      dontUnpack = true;
      dontConfigure = true;
      dontBuild = true;

      outputs = [
        "out"
        "steamcompattool"
      ];

      installPhase = ''
        runHook preInstall

        # Make it impossible to add to an environment. You should use the appropriate NixOS option.
        # Also leave some breadcrumbs in the file.
        echo "${finalAttrs.pname} should not be installed into environments. Please use programs.steam.extraCompatPackages instead." > $out

        mkdir $steamcompattool
        ln -s $src/* $steamcompattool
        rm $steamcompattool/compatibilitytool.vdf
        cp $src/compatibilitytool.vdf $steamcompattool

        runHook postInstall
      '';

      preFixup = ''
        substituteInPlace "$steamcompattool/compatibilitytool.vdf" \
          --replace-fail "$toolName" "$steamDisplayName"
      '';

      meta = {
        platforms = builtins.attrNames variants;
        sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
      }
      // meta;
    };
}
