{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  undmg,
  versionCheckHook,
  xz,
  bzip2,
  bun,
  coreutils,
  python3,
  runtimeShell,
}:

let
  inherit (stdenv.hostPlatform) system;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "kiro-cli";
  version = "2.10.0";

  src =
    let
      darwinDmg = fetchurl {
        url = "https://desktop-release.q.us-east-1.amazonaws.com/${finalAttrs.version}/Kiro%20CLI.dmg";
        hash = "sha256-NDeyXQO9NBsK3xqAEcO1gGn9ta+ZVQ1GNwZ4hbGUe3Q=";
      };
    in
    {
      x86_64-linux = fetchurl {
        url = "https://desktop-release.q.us-east-1.amazonaws.com/${finalAttrs.version}/kirocli-x86_64-linux.tar.gz";
        hash = "sha256-cJl6CyYCzbLpB6m+W9Tx7enaPzijgjOBjdmG6CPMM8k=";
      };
      aarch64-linux = fetchurl {
        url = "https://desktop-release.q.us-east-1.amazonaws.com/${finalAttrs.version}/kirocli-aarch64-linux.tar.gz";
        hash = "sha256-39hKSRi1l5ruSqObViksJkufiCOvLTaIkQzT3sNQFQQ=";
      };
      x86_64-darwin = darwinDmg;
      aarch64-darwin = darwinDmg;
    }
    .${system} or (throw "Unsupported system: ${system}");

  sourceRoot = if stdenv.hostPlatform.isDarwin then "Kiro CLI.app" else "kirocli";

  strictDeps = true;

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      autoPatchelfHook
      python3
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
    install -Dm755 bin/kiro-cli      $out/libexec/kiro-cli/kiro-cli
    install -Dm755 bin/kiro-cli-chat $out/libexec/kiro-cli/kiro-cli-chat
    install -Dm755 bin/kiro-cli-term $out/libexec/kiro-cli/kiro-cli-term
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

  # On Linux, kiro-cli-chat embeds a generic-Linux-glibc bun (101 MiB) and a
  # tui.js bundle. On first --tui run it self-extracts those to
  # ~/.local/share/kiro-cli/ and exec()s the extracted bun, which fails on
  # NixOS because the dynamic loader path /lib64/ld-linux-x86-64.so.2 doesn't
  # exist (issue #516857). To fix this without an FHS env we:
  #
  #   1. Run the (autopatchelf'd) kiro-cli-chat once at build time to extract
  #      the embedded assets.
  #   2. Stash bun.sha256, tui.js, and tui.js.sha256 under $out/share/kiro-cli/
  #      and discard the extracted bun.
  #   3. Zero out the embedded bun bytes inside kiro-cli-chat in-place. The
  #      extraction-skip check only compares the on-disk bun.sha256 file to
  #      the embedded hash; the bun bytes themselves are never re-read once
  #      we pre-populate the data dir, so zeroing them is safe and lets the
  #      Nix store binary cache compress that 101 MiB region to almost nothing.
  #   4. Wrap kiro-cli, kiro-cli-chat, and kiro-cli-term so each invocation
  #      pre-populates the user's ~/.local/share/kiro-cli/ with a symlink to
  #      ${bun}/bin/bun and the build-time bun.sha256/tui.js/tui.js.sha256.
  #      kiro-cli-chat then sees its assets are up-to-date, skips extraction,
  #      and exec()s the nixpkgs bun.
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    # autoPatchelfHook normally runs at the end of fixupPhase, after our
    # postFixup. We need the binaries patched first so we can execute
    # kiro-cli-chat to trigger asset extraction. Run it explicitly here.
    autoPatchelfPostFixup

    extractDir=$(mktemp -d)
    mkdir -p "$extractDir/.local/share/kiro-cli"

    # kiro-cli-chat opens an interactive TUI and waits for input. Closing
    # stdin and using a short timeout lets it run far enough to extract the
    # embedded assets before we kill it.
    HOME="$extractDir" \
    XDG_DATA_HOME="$extractDir/.local/share" \
    KIRO_DISABLE_TELEMETRY=1 \
    KIRO_NO_AUTO_UPDATE=1 \
    KIRO_DISABLE_TRUECOLOR=1 \
    KIRO_API_KEY=nixpkgs-build-extract-only \
      timeout --preserve-status --signal=TERM 30s \
        $out/libexec/kiro-cli/kiro-cli-chat chat --tui --agent-engine=v2 \
        < /dev/null > "$extractDir/extract.log" 2>&1 \
      || true

    for f in bun bun.sha256 tui.js tui.js.sha256; do
      if [[ ! -s "$extractDir/.local/share/kiro-cli/$f" ]]; then
        echo "kiro-cli build-time extraction did not produce $f" >&2
        ls -la "$extractDir/.local/share/kiro-cli/" >&2
        echo "--- extraction log: ---" >&2
        cat "$extractDir/extract.log" >&2 || true
        echo "--- end log ---" >&2
        exit 1
      fi
    done

    install -d $out/share/kiro-cli
    install -m 0644 "$extractDir/.local/share/kiro-cli/bun.sha256"    $out/share/kiro-cli/bun.sha256
    install -m 0644 "$extractDir/.local/share/kiro-cli/tui.js"        $out/share/kiro-cli/tui.js
    install -m 0644 "$extractDir/.local/share/kiro-cli/tui.js.sha256" $out/share/kiro-cli/tui.js.sha256

    python3 ${./zero-embedded-bun.py} \
      $out/libexec/kiro-cli/kiro-cli-chat \
      "$extractDir/.local/share/kiro-cli/bun" \
      "$extractDir/.local/share/kiro-cli/bun.sha256"

    rm -rf "$extractDir"

    mkdir -p $out/bin
    for binname in kiro-cli kiro-cli-chat kiro-cli-term; do
      substitute ${./kiro-cli-wrapper.sh} $out/bin/$binname \
        --subst-var-by shell ${runtimeShell} \
        --subst-var-by coreutils ${coreutils} \
        --subst-var-by bun ${lib.getExe bun} \
        --subst-var-by share $out/share/kiro-cli \
        --subst-var-by libexec $out/libexec/kiro-cli/$binname
      chmod 0755 $out/bin/$binname
    done
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Command-line interface for Kiro, an agentic IDE";
    homepage = "https://kiro.dev";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = [ lib.maintainers.jamesward ];
    mainProgram = "kiro-cli";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
