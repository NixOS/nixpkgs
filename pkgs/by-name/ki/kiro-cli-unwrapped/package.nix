{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  undmg,
  versionCheckHook,
  xz,
  bzip2,
}:

# The raw upstream binaries, autoPatchelf'd so kiro-cli itself runs on NixOS.
# This is enough for --version/--help and most of the CLI. The one thing it
# does NOT fix is the new TUI: on first `--tui` run kiro-cli-chat extracts an
# embedded, generic-glibc `bun` (interpreter /lib64/ld-linux-x86-64.so.2) to
# ~/.local/share/kiro-cli/ and exec()s it, which fails on NixOS (#516857).
# That is handled by the kiro-cli package, which wraps this one in an FHS env.
stdenv.mkDerivation (finalAttrs: {
  pname = "kiro-cli-unwrapped";
  version = "2.21.0";

  __structuredAttrs = true;

  src =
    {
      x86_64-linux = fetchurl {
        url = "https://desktop-release.q.us-east-1.amazonaws.com/${finalAttrs.version}/kirocli-x86_64-linux.tar.gz";
        hash = "sha256-1GxIIb4u8GZGYqHsjsV/GlREsYQBD1JSpF0yW3a9Nf4=";
      };
      aarch64-linux = fetchurl {
        url = "https://desktop-release.q.us-east-1.amazonaws.com/${finalAttrs.version}/kirocli-aarch64-linux.tar.gz";
        hash = "sha256-Z0QmrgQgE2J2ez+KK5tGqbI+lOOXSEXxxIbeSbDFojo=";
      };
      aarch64-darwin = fetchurl {
        url = "https://desktop-release.q.us-east-1.amazonaws.com/${finalAttrs.version}/Kiro%20CLI.dmg";
        hash = "sha256-uv/a1dPN+0iGuvQYgDEEse555bsVQV9j5J8chV8BUQ8=";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  sourceRoot = if stdenv.hostPlatform.isDarwin then "Kiro CLI.app" else "kirocli";

  strictDeps = true;

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      autoPatchelfHook
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      undmg
    ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc.lib
    xz
    bzip2
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm755 bin/kiro-cli      -t $out/bin
    install -Dm755 bin/kiro-cli-chat -t $out/bin
    install -Dm755 bin/kiro-cli-term -t $out/bin
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/bin $out/Applications
    cp -r "../Kiro CLI.app" "$out/Applications/"
    ln -s "$out/Applications/Kiro CLI.app/Contents/MacOS/kiro-cli" $out/bin/kiro-cli
    for bin in kiro-cli-chat kiro-cli-term; do
      if [[ -e "$out/Applications/Kiro CLI.app/Contents/MacOS/$bin" ]]; then
        ln -s "$out/Applications/Kiro CLI.app/Contents/MacOS/$bin" "$out/bin/$bin"
      fi
    done
  ''
  + ''
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
