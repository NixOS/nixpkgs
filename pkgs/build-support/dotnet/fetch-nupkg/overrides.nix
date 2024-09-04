{
  autoPatchelfHook,
  dotnetCorePackages,
  fontconfig,
  lib,
  stdenv,
}:
{
  # e.g.
  # "Package.Id" =
  #   package:
  #   package.overrideAttrs (old: {
  #     buildInputs = old.buildInputs or [ ] ++ [ hello ];
  #   });

  "SkiaSharp.NativeAssets.Linux" =
    package:
    package.overrideAttrs (old: {
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
    });
}
