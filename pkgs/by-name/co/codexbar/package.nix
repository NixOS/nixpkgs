{
  lib,
  stdenv,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  unzip,
  curl,
  sqlite,
  versionCheckHook,
  writeShellScript,
  nix-update,
  jq,
  common-updater-scripts,
}:

stdenvNoCC.mkDerivation (
  finalAttrs:
  let
    darwin = stdenvNoCC.hostPlatform.isDarwin;

    macos = {
      url = "https://github.com/steipete/CodexBar/releases/download/v${finalAttrs.version}/CodexBar-macos-universal-${finalAttrs.version}.zip";
      hash = "sha256-abKC78odg8FNhK1nzsW55PmM/qHORuAO+QJ5LsWCp6Q=";
    };

    sources = {
      aarch64-darwin = macos;
      aarch64-linux = {
        url = "https://github.com/steipete/CodexBar/releases/download/v${finalAttrs.version}/CodexBarCLI-v${finalAttrs.version}-linux-aarch64.tar.gz";
        hash = "sha256-bEjqR4FUwt8yVgVyp+haq46FD6QTtu5iV/9ozs54nYk=";
      };
      x86_64-linux = {
        url = "https://github.com/steipete/CodexBar/releases/download/v${finalAttrs.version}/CodexBarCLI-v${finalAttrs.version}-linux-x86_64.tar.gz";
        hash = "sha256-RL6ZAXadbU0RHKyui2eapcWFsm93r6T2Q2sJKCBgkf0=";
      };
    };
  in
  {
    pname = "codexbar";
    version = "0.76.0";
    __structuredAttrs = true;
    strictDeps = true;

    src = fetchurl {
      inherit
        (sources.${stdenvNoCC.hostPlatform.system}
          or (throw "codexbar: unsupported platform ${stdenvNoCC.hostPlatform.system}")
        )
        url
        hash
        ;
    };

    sourceRoot = ".";

    nativeBuildInputs =
      if darwin then
        [
          makeWrapper
          unzip
        ]
      else
        [ autoPatchelfHook ];

    installPhase =
      if darwin then
        ''
          runHook preInstall

          mkdir -p $out/Applications
          cp -r CodexBar.app $out/Applications
          makeWrapper $out/Applications/CodexBar.app/Contents/MacOS/CodexBar $out/bin/codexbar

          runHook postInstall
        ''
      else
        ''
          runHook preInstall

          mkdir -p $out/bin $out/libexec/codexbar
          install -m755 CodexBarCLI $out/libexec/codexbar/codexbar
          # Located relative to the executable at runtime, so it stays beside it.
          install -m644 VERSION $out/libexec/codexbar/VERSION
          cp -r CodexBar_CodexBarCore.bundle $out/libexec/codexbar/
          ln -s ../libexec/codexbar/codexbar $out/bin/codexbar
          install -Dm644 THIRD_PARTY_NOTICES $out/share/doc/codexbar/THIRD_PARTY_NOTICES

          runHook postInstall
        '';

    passthru.updateScript = writeShellScript "update-codexbar" ''
      ${lib.getExe nix-update} codexbar --url=https://github.com/steipete/CodexBar
      latestVersion=$(nix eval --raw --file . codexbar.version)
      if [[ "$latestVersion" == "$UPDATE_NIX_OLD_VERSION" ]]; then
        exit 0
      fi
      for system in ${lib.concatStringsSep " " (builtins.attrNames sources)}; do
        url=$(nix eval --raw --file . codexbar.src.url --system "$system")
        hash=$(nix store prefetch-file --json "$url" | ${lib.getExe jq} --raw-output .hash)
        ${lib.getExe' common-updater-scripts "update-source-version"} codexbar "$latestVersion" "$hash" --system="$system" --ignore-same-version --ignore-same-hash
      done
    '';

    meta = {
      description = "Show usage stats for AI coding-provider limits";
      homepage = "https://codex.bar/";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        Br1ght0ne
        kinnrai
      ];
      platforms = builtins.attrNames sources;
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      mainProgram = "codexbar";
    };
  }
  // lib.optionalAttrs stdenvNoCC.hostPlatform.isLinux {
    buildInputs = [
      curl
      sqlite
      (lib.getLib stdenv.cc.cc)
    ];

    nativeInstallCheckInputs = [ versionCheckHook ];
    doInstallCheck = true;
  }
)
