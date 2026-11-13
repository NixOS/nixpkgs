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
        if [[ -f $src/proton ]]; then
          rm $steamcompattool/proton
          cp $src/proton $steamcompattool
        fi

        runHook postInstall
      '';

      preFixup = ''
        substituteInPlace "$steamcompattool/compatibilitytool.vdf" \
          --replace-fail "$toolName" "$steamDisplayName"

        # wineboot re-applies wine.inf when its mtime differs from .update-timestamp.
        # Every file in the Nix store has the same mtime, so that never happens and
        # upgraded prefixes miss anything new in wine.inf, such as new services.
        # Removing the timestamp when the prefix version changes restores the behaviour
        # of a normal install. Tools other than Proton don't ship a proton script.
        if [[ -f $src/proton ]]; then
          substituteInPlace "$steamcompattool/proton" \
            --replace-fail "            self.upgrade_pfx(old_ver)" \
                           "            self.upgrade_pfx(old_ver)
                    if old_ver != CURRENT_PREFIX_VERSION and file_exists(self.prefix_dir + '.update-timestamp', follow_symlinks=False):
                        os.remove(self.prefix_dir + '.update-timestamp')"
        fi
      '';

      meta = {
        platforms = builtins.attrNames variants;
        sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
      }
      // meta;
    };
}
