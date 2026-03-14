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
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    cargo-tauri.gst-plugin
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

    fixupScript = lib.optionalString stdenv.hostPlatform.isLinux ''
      gappsWrapperArgs+=(
        --prefix WEBKIT_GST_ALLOWED_URI_PROTOCOLS : "asset"
        # Not picked up automatically by the wrappers from the propagatedBuildInputs.
        --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "${cargo-tauri.gst-plugin}/lib/gstreamer-1.0/"
      )
    '';

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
