{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_12,
  nodejs,
  makeWrapper,
  installShellFiles,
  autoPatchelfHook,
  patchelfUnstable,
  cacert,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cloudflare-cf";
  version = "1.0.0-beta.10";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "cf";
    tag = "cf@${finalAttrs.version}";
    hash = "sha256-rq6cBYVqPktI3Vh4mRosUV2LnvuyY3H3YY0vUimSzmg=";
  };

  pnpmWorkspaces = [ "cf" ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    pnpm = pnpm_12;
    fetcherVersion = 4;
    hash = "sha256-W0a7IvYB791c7gkTI+XxVXEJgEAEbDTjX1VvnPcBs9I=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_12
    pnpmConfigHook
    makeWrapper
    installShellFiles
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
    # Older patchelf corrupts libvips's .init section when extending its RPATH.
    # https://github.com/NixOS/patchelf/issues/639
    patchelfUnstable
  ];

  # The npm distribution includes native workerd and sharp binaries.
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

  env.NODE_OPTIONS = "--max-old-space-size=4096";

  buildPhase = ''
    runHook preBuild
    pnpm --filter cf run build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    pnpm config set --location=project injectWorkspacePackages true
    pnpm --filter cf --prod deploy $out/lib/cloudflare-cf
    makeWrapper ${lib.getExe nodejs} $out/bin/cf \
      --inherit-argv0 \
      --add-flags $out/lib/cloudflare-cf/bin/cf \
      --prefix PATH : ${lib.makeBinPath [ nodejs ]} \
      --set-default SSL_CERT_FILE ${cacert}/etc/ssl/certs/ca-bundle.crt
    ln -s cf $out/bin/cloudflare
    runHook postInstall
  '';

  preFixup = ''
    stripExclude+=("*.js" "*.mjs" "*.ts" "*.map" "*.json" "*.md")
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash zsh fish; do
      CF_SEND_TELEMETRY=false DO_NOT_TRACK=1 $out/bin/cf complete "$shell" > "cf.$shell"
      # Bash's readonly globals would collide when both names are loaded.
      if [[ $shell == bash ]]; then
        sed -i 's/ShellCompDirective/__cf_ShellCompDirective/g' "cf.$shell"
      fi
      installShellCompletion --cmd cf --$shell "cf.$shell"
      # Upstream generates scripts for cf even when invoked as cloudflare.
      sed 's/cf/cloudflare/g' "cf.$shell" > "cloudflare.$shell"
      installShellCompletion --cmd cloudflare --$shell "cloudflare.$shell"
    done
  '';

  passthru.updateScript = nix-update-script {
    # Upstream currently publishes beta releases.
    extraArgs = [
      "--version=unstable"
      "--version-regex=cf@(.*)"
    ];
  };

  passthru.tests.functional = callPackage ./tests.nix {
    inherit nodejs;
    cloudflare-cf = finalAttrs.finalPackage;
  };

  meta = {
    description = "Command-line interface for the Cloudflare API and Workers";
    homepage = "https://github.com/cloudflare/cf";
    changelog = "https://github.com/cloudflare/cf/blob/cf@${finalAttrs.version}/packages/cli/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ connornelson ];
    mainProgram = "cf";
    # The CLI is built from source; npm supplies native binaries and WASM.
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
      binaryBytecode
    ];
    # Platforms supported by both Nixpkgs and workerd's npm distribution.
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
