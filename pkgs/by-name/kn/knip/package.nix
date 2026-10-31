{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_11,
  typescript_7,
  nodejs-slim,
  makeBinaryWrapper,
  versionCheckHook,
  nix-update-script,
}:
let
  pnpm = pnpm_11;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "knip";
  version = "6.43.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "webpro-nl";
    repo = "knip";
    tag = "knip@${finalAttrs.version}";
    hash = "sha256-oybKKsbXqdLeN52xiP+Fd+7MgLZi8ruaSUZex7yabJk=";
  };

  pnpmWorkspaces = [ "knip" ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    inherit pnpm;
    fetcherVersion = 5;
    hash = "sha256-J/mVcEI4F/toYWavderN5iwi2VBMh0o0vfS4Cb7V2pc=";
  };

  nativeBuildInputs = [
    nodejs-slim
    pnpmConfigHook
    pnpm
    makeBinaryWrapper
    typescript_7
  ];

  buildPhase = ''
    runHook preBuild

    # Equivalent to upstream's `pnpm run build`, but using typescript_7 from
    # nixpkgs instead of the prebuilt tsc binary from npm.
    pushd packages/knip
    pnpm run generate-plugin-defs
    tsc
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    pnpm --filter knip deploy --prod --offline --ignore-scripts $out/lib/knip
    rm $out/lib/knip/{pnpm-lock.yaml,pnpm-workspace.yaml}

    makeWrapper ${lib.getExe nodejs-slim} $out/bin/knip \
      --add-flags $out/lib/knip/bin/knip.js

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=knip@(.*)" ];
  };

  meta = {
    description = "Find and fix unused dependencies, exports and files in JavaScript and TypeScript projects";
    homepage = "https://knip.dev";
    changelog = "https://github.com/webpro-nl/knip/releases/tag/knip@${finalAttrs.version}";
    license = lib.licenses.isc;
    mainProgram = "knip";
    maintainers = with lib.maintainers; [ vitorpavani ];
    platforms = nodejs-slim.meta.platforms;
    # oxc-parser and oxc-resolver ship prebuilt native bindings and WASM from npm.
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
      binaryBytecode
    ];
  };
})
