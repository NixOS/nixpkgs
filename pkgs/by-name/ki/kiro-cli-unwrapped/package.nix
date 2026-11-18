{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  versionCheckHook,
}:

# The raw upstream binary, autoPatchelf'd so kiro-cli itself runs on NixOS.
# This is enough for --version/--help and most of the CLI. The one thing it
# does NOT fix is the new TUI: on first `--tui` run kiro-cli extracts an
# embedded, generic-glibc `bun` (interpreter /lib64/ld-linux-x86-64.so.2) to
# ~/.local/share/kiro-cli/ and exec()s it, which fails on NixOS (#516857).
# That is handled by the kiro-cli package, which wraps this one in an FHS env.
stdenv.mkDerivation (finalAttrs: {
  pname = "kiro-cli-unwrapped";
  version = "3.3.0";

  __structuredAttrs = true;

  src =
    let
      # Since 3.0, macOS ships as a single universal tarball.
      darwin = fetchurl {
        url = "https://desktop-release.q.us-east-1.amazonaws.com/${finalAttrs.version}/kirocli-universal-darwin.tar.gz";
        hash = "sha256-PXOKl/HAwYHQD2YCnpkddu++I3SNIxHrdfIFyLnJx5c=";
      };
    in
    {
      x86_64-linux = fetchurl {
        url = "https://desktop-release.q.us-east-1.amazonaws.com/${finalAttrs.version}/kirocli-x86_64-linux.tar.gz";
        hash = "sha256-uIFCqgJ4lQSsd/327oKfD0vcnOLl3QzHMIThBQA8j8M=";
      };
      aarch64-linux = fetchurl {
        url = "https://desktop-release.q.us-east-1.amazonaws.com/${finalAttrs.version}/kirocli-aarch64-linux.tar.gz";
        hash = "sha256-GHIPfcU2hImxZziMJ8R2gIkgMmGcT20JnP3cF2EeA54=";
      };
      aarch64-darwin = darwin;
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  sourceRoot = "kirocli";

  strictDeps = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc.lib
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  dontConfigure = true;
  dontBuild = true;

  # Since 3.0, upstream ships a single standalone `kiro-cli` binary on every
  # platform (kiro-cli-chat and kiro-cli-term are gone).
  installPhase = ''
    runHook preInstall
    install -Dm755 bin/kiro-cli -t $out/bin
    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Command-line interface for Kiro, an agentic IDE";
    homepage = "https://kiro.dev";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [
      jamesward
      pmw
    ];
    mainProgram = "kiro-cli";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
