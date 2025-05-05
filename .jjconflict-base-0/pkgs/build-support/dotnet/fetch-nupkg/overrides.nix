{
  autoPatchelfHook,
  dotnetCorePackages,
  fontconfig,
  lib,
  libICE,
  libSM,
  libX11,
  stdenv,
  writeText,
}:
{
  # e.g.
  # "Package.Id" =
  #   package:
  #   package.overrideAttrs (old: {
  #     buildInputs = old.buildInputs or [ ] ++ [ hello ];
  #   });

  "Avalonia" =
    package:
    package.overrideAttrs (
      old:
      let
        # These versions have a runtime error when built with `dotnet publish --no-build`
        # When attempting to draw a window, Avalonia will throw "No precompiled XAML found"
        #
        # Introduced in https://github.com/AvaloniaUI/Avalonia/pull/13840
        # Fixed by https://github.com/AvaloniaUI/Avalonia/pull/16835
        affectedVersions = [
          "11.1.0-beta1"
          "11.1.0-beta2"
          "11.1.0-rc1"
          "11.1.0-rc2"
          "11.1.0"
          "11.1.1"
          "11.1.2-rc1"
          "11.1.2"
          "11.1.3"
          "11.2.0-beta1"
        ];
      in
      lib.optionalAttrs (builtins.elem old.version affectedVersions) {
        postPatch = ''
          substituteInPlace {build,buildTransitive}/AvaloniaBuildTasks.targets \
            --replace-fail 'BeforeTargets="CopyFilesToOutputDirectory;BuiltProjectOutputGroup"' \
                           'BeforeTargets="CopyFilesToOutputDirectory;BuiltProjectOutputGroup;ComputeResolvedFilesToPublishList"'
        '';
      }
    );

  "Avalonia.X11" =
    package:
    package.overrideAttrs (
      old:
      lib.optionalAttrs (!stdenv.hostPlatform.isDarwin) {
        setupHook = writeText "setupHook.sh" ''
          prependToVar dotnetRuntimeDeps \
            "${lib.getLib libICE}" \
            "${lib.getLib libSM}" \
            "${lib.getLib libX11}"
        '';
      }
    );

  "SkiaSharp.NativeAssets.Linux" =
    package:
    package.overrideAttrs (
      old:
      lib.optionalAttrs stdenv.hostPlatform.isLinux {
        nativeBuildInputs = old.nativeBuildInputs or [ ] ++ [ autoPatchelfHook ];

        buildInputs = old.buildInputs or [ ] ++ [ fontconfig ];

        preInstall =
          old.preInstall or ""
          + ''
            cd runtimes
            for platform in *; do
              [[ $platform == "${dotnetCorePackages.systemToDotnetRid stdenv.hostPlatform.system}" ]] ||
                rm -r "$platform"
            done
            cd - >/dev/null
          '';
      }
    );
}
