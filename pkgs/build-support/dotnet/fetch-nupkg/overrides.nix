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

  "Avalonia.X11" =
    package:
    package.overrideAttrs (
      old:
      lib.optionalAttrs (!stdenv.isDarwin) {
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
      lib.optionalAttrs stdenv.isLinux {
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
