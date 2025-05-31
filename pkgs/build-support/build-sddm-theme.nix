{
  lib,
  formats,
  stdenvNoCC,
  # testGreeter dependencies
  writeShellScriptBin,
  kdePackages,
  libsForQt5,
  ...
}:
{
  pname,
  version,
  src,
  # BuildInputs to add to the sddm package.
  sddmBuildInputs ? [ ],
  # Name of the theme that should be entered into the sddm configuration.
  # ```
  # [Theme]
  # Current="${themeName}"
  # ```
  themeName,
  # The directory that should be copied to `$out/share/sddm/themes/`
  srcThemeDir,
  # The path to the `<theme>.conf` file
  configPath,
  # Override values in the `<theme>.conf` file
  configOverrides ? { },
  # `qt6` or `qt5`
  qtVersion ? "qt6",
  meta ? { },
}:
let
  themeOutPath = "/share/sddm/themes/${pname}";

  outputDerivation = stdenvNoCC.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;

    patchPhase =
      let
        iniFormat = formats.ini { };
        configOverridesFile = iniFormat.generate "${pname}-config-overrides" { General = configOverrides; };
      in
      ''
        runHook abc
        runHook prePatch

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

    dontWrapQtApps = true;

    passthru = rec {
      sddmThemeName = themeName;
      sddmThemeDir = "${outputDerivation}/${themeOutPath}";

      sddmPackage =
        let
          rawPackage =
            {
              "qt6" = kdePackages.sddm;
              "qt5" = libsForQt5.sddm;
            }
            ."${qtVersion}";
        in
        rawPackage.overrideAttrs (
          _: prev: {
            buildInputs = prev.buildInputs ++ sddmBuildInputs;
          }
        );

      testGreeter =
        let
          greeterBin = "sddm-greeter${lib.optionalString (qtVersion == "qt6") "-qt6"}";
        in
        # TODO mainProgram for sddmPackage
        writeShellScriptBin "${pname}-test-greeter" ''
          ${sddmPackage}/bin/${greeterBin} \
            --test-mode --theme ${sddmThemeDir}
        '';
    };
  };
in
outputDerivation
