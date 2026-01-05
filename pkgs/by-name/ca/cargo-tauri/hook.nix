{
  lib,
  stdenv,
  makeSetupHook,
  cargo,
  cargo-tauri,
  rust,
  # The subdirectory of `target/` from which to copy the build artifacts
  targetSubdirectory ? stdenv.hostPlatform.rust.cargoShortTarget,
}:

let
  kernelName = stdenv.hostPlatform.parsed.kernel.name;
in
makeSetupHook {
  name = "tauri-hook";

  propagatedBuildInputs = [
    cargo
    cargo-tauri
  ];

  substitutions = {
    inherit targetSubdirectory;
    inherit (rust.envVars) rustHostPlatformSpec setEnv;

    # A map of the bundles used for Tauri's different supported platforms
    # https://github.com/tauri-apps/tauri/blob/23a912bb84d7c6088301e1ffc59adfa8a799beab/README.md#platforms
    defaultTauriBundleType =
      {
        darwin = "app";
        linux = "deb";
      }
      .${kernelName} or (throw "${kernelName} is not supported by cargo-tauri.hook");

    # $targetDir is the path to the build artifacts (i.e., `./target/release`)
    installScript =
      {
        darwin = ''
          mkdir -p $out
          mv "$targetDir"/bundle/macos $out/Applications
        '';

        linux = ''
          mkdir -p $out
          mv "$targetDir"/bundle/deb/*/data/usr/* $out/
        '';
      }
      .${kernelName} or (throw "${kernelName} is not supported by cargo-tauri.hook");
  };

  meta = {
    inherit (cargo-tauri.meta) maintainers broken;
    # Platforms that Tauri supports bundles for
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
  };
} ./hook.sh
