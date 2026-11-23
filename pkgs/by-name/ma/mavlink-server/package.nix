{
  lib,
  stdenv,
  fetchurl,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mavlink-server";
  version = "0.11.1";

  # build.rs installs rustup targets and trunk to build the wasm frontend and reads
  # git metadata, so building from source needs changes upstream first.
  src =
    let
      hashes = {
        "x86_64-unknown-linux-musl" = "sha256-kqMTlol1dBmG7yHre+4JhDQzLvYYgCCYwl1+mj2Z8LY=";
        "aarch64-unknown-linux-musl" = "sha256-6A1hEzKeR+1zRzwM0NeTpxG11g0Ts1OFMgUb4mlB788=";
        "armv7-unknown-linux-musleabihf" = "sha256-XS4Q5NekyQ4asKvYRDgMC+T8skCIBlZtBPzbm4IVHXs=";
        "x86_64-apple-darwin" = "sha256-jeFI9e1aR/4eY6B7LPIy3Q/f/Dkxt4SlvVYq0gy59+g=";
        "aarch64-apple-darwin" = "sha256-R/Q/FZRg0Gmzk3qqmyjCVSaPVrhEyMKNUuBWTHWhpqM=";
      };

      systemToTarget = {
        "x86_64-linux" = "x86_64-unknown-linux-musl";
        "aarch64-linux" = "aarch64-unknown-linux-musl";
        "armv7l-linux" = "armv7-unknown-linux-musleabihf";
        "x86_64-darwin" = "x86_64-apple-darwin";
        "aarch64-darwin" = "aarch64-apple-darwin";
      };

      target =
        systemToTarget.${stdenv.hostPlatform.system}
          or (throw "mavlink-server: no upstream binary for ${stdenv.hostPlatform.system}");
    in
    fetchurl {
      url = "https://github.com/bluerobotics/mavlink-server/releases/download/${finalAttrs.version}/mavlink-server-${target}";
      hash = hashes.${target};
    };

  dontUnpack = true;
  strictDeps = true;
  __structuredAttrs = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 "$src" "$out/bin/mavlink-server"
    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  meta = {
    description = "MAVLink router and broker with a REST API and web interface";
    homepage = "https://github.com/bluerobotics/mavlink-server";
    changelog = "https://github.com/bluerobotics/mavlink-server/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "mavlink-server";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "armv7l-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ patrickelectric ];
  };
})
