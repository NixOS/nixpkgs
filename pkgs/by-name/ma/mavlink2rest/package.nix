{
  lib,
  stdenv,
  fetchurl,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mavlink2rest";
  version = "1.1.1";

  # Source builds need HTML and JS assets bundled at build time.
  src =
    let
      hashes = {
        "x86_64-unknown-linux-musl" = "sha256-k11oV2tjESg3iCxxydo/2SsQosiKvSeJeyDh+0VMBtk=";
        "aarch64-unknown-linux-musl" = "sha256-2a3HNpmDQRjYlc2MT4v+g81YseUUjpVSxaqlxMHOrvs=";
        "armv7-unknown-linux-musleabihf" = "sha256-UV1irG68zT+/YAzc4rlQblQm3Q/E2evP9+IGFM0yCos=";
        "x86_64-apple-darwin" = "sha256-tqV8ozLprkDgT1j7Oxt2empXVglSx5FRZOI4YNecBxI=";
        "aarch64-apple-darwin" = "sha256-4rzM34kkAKuO4QMGm+GzAAuGkXj68sTUP9jXNWS4qWk=";
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
          or (throw "mavlink2rest: no upstream binary for ${stdenv.hostPlatform.system}");
    in
    fetchurl {
      url = "https://github.com/mavlink/mavlink2rest/releases/download/${finalAttrs.version}/mavlink2rest-${target}";
      hash = hashes.${target};
    };

  dontUnpack = true;

  strictDeps = true;
  __structuredAttrs = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 "$src" "$out/bin/mavlink2rest"
    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  meta = {
    description = "REST API server for MAVLink";
    homepage = "https://github.com/mavlink/mavlink2rest";
    changelog = "https://github.com/mavlink/mavlink2rest/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "mavlink2rest";
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
