{
  lib,
  formats,
  stdenvNoCC,
  # testGreeter dependencies
  writeShellScriptBin,
  kdePackages,
}:
lib.extendMkDerivation {
  constructDrv = stdenvNoCC.mkDerivation;

  excludeDrvArgNames = [
    "sddmBuildInputs"
    "srcThemeDir"
    "configPath"
    "configOverrides"
  ];

  extendDrvArgs =
    finalAttrs:
    {
      # BuildInputs to add to the sddm package.
      sddmBuildInputs ? [ ],
      # Directory that should be copied to `$out/share/sddm/themes/`
      srcThemeDir ? ".",
      # Path to the `<theme>.conf` file
      configPath,
      # Override values in the `<theme>.conf` file
      configOverrides ? { },

      passthru ? { },
      meta ? { },
      ...
    }:
    let
      themeOutPath = "share/sddm/themes/${finalAttrs.pname}";
    in
    {
      __structuredAttrs = true;
      strictDeps = true;

      dontConfigure = true;
      dontBuild = true;

      patchPhase =
        let
          iniFormat = formats.ini { };
          configOverridesFile = iniFormat.generate "${finalAttrs.pname}-config-overrides" {
            General = configOverrides;
          };
        in
        ''
          runHook prePatch

          if [[ ! -f "${srcThemeDir}/metadata.desktop" ]]; then
            echo "buildSddmThemePackage: metadata.desktop not found in '${srcThemeDir}'" >&2
            exit 1
          fi

          if [[ ! -f "${srcThemeDir}/${configPath}" ]]; then
            echo "buildSddmThemePackage: configPath '${configPath}' not found in '${srcThemeDir}'" >&2
            exit 1
          fi

          # Override `metadata.desktop` to point to the supplied `configPath`.
          # This is sometimes needed to select a theme in packages with multiple themes.
          sed -i \
            "s|ConfigFile=.*\\.conf|ConfigFile=${configPath}|" \
            "${srcThemeDir}/metadata.desktop"

          ${lib.optionalString (
            configOverrides != { }
          ) ''ln -sf ${configOverridesFile} "${srcThemeDir}/${configPath}.user"''}

          runHook postPatch
        '';

      installPhase = ''
        runHook preInstall

        mkdir -p "$out/${themeOutPath}"
        cp -r "${srcThemeDir}"/* "$out/${themeOutPath}"

        runHook postInstall
      '';

      passthru = passthru // {
        sddmThemeDir = "${finalAttrs.finalPackage}/${themeOutPath}";

        # Add the dependencies this theme needs to the given sddm package
        sddmPackageWith =
          sddm:
          sddm.override (old: {
            extraPackages = old.extraPackages or [ ] ++ sddmBuildInputs;
          });

        testGreeter = writeShellScriptBin "${finalAttrs.pname}-test-greeter" ''
          ${lib.getExe' (finalAttrs.passthru.sddmPackageWith kdePackages.sddm) "sddm-greeter-qt6"} \
            --test-mode --theme ${finalAttrs.passthru.sddmThemeDir}
        '';
      };

      meta = {
        platforms = lib.platforms.linux;
      }
      // meta;
    };
}
