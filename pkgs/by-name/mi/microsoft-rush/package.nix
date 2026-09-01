{
  fetchFromGitHub,
  fetchPnpmDeps,
  lib,
  makeWrapper,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  stdenv,
  testers,
  yq,
}:

let
  pnpm = pnpm_10;
  rushWorkspace = "@microsoft/rush...";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "microsoft-rush";
  version = "5.178.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "rushstack";
    tag = "@microsoft/rush_v${finalAttrs.version}";
    hash = "sha256-e3M/wbdstVUZR0ShEHO7Bemz2BYHZn7tIIZP33UrRu8=";
  };

  # We have to patch some files to build rush with pnpm,
  # as the repo is designed to be built with rush itself
  postPatch = ''
    # Rush usually places the pnpm lock file in a subdirectory (common/temp/default),
    # but we need it at the root of the workspace
    #
    # But for this to work, we need to patch a few things:
    # - We remove rush-specific overrides and checksums
    # - We set injectWorkspacePackages to true to avoid ERR_PNPM_LOCKFILE_CONFIG_MISMATCH
    # - We adjust the importer paths be relative to the root of the workspace instead of the common/temp/default subdirectory
    ${lib.getExe yq} -y '
      del(.overrides, .packageExtensionsChecksum, .pnpmfileChecksum)
      | .settings.injectWorkspacePackages = true
      | .importers |= with_entries(.key |= sub("^\\.\\./\\.\\./\\.\\./"; ""))
    ' common/config/subspaces/default/pnpm-lock.yaml > pnpm-lock.yaml

    # Since rush doesn't provide a committed pnpm workspace file, we synthesize one from the pnpm lock file
    ${lib.getExe yq} -y \
      '{ packages: (.importers | keys | map(select(. != "."))) }' \
      pnpm-lock.yaml > pnpm-workspace.yaml
  '';

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      postPatch
      env
      pnpmWorkspaces
      ;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-3zRdVvJQTT7jBaOm4SdM76LmikjaTjVCkZXZK+MFf7A=";
  };

  pnpmWorkspaces = [ rushWorkspace ];

  env = {
    npm_config_auto_install_peers = "false";
    npm_config_inject_workspace_packages = "true";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    pnpm
    pnpmConfigHook
  ];

  buildPhase = ''
    runHook preBuild

    pnpm --filter '${rushWorkspace}' --recursive --if-present run _phase:lite-build
    pnpm --filter '${rushWorkspace}' --recursive --if-present run _phase:build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    pnpm --filter @microsoft/rush deploy --prod --offline "$out/libexec/microsoft-rush"

    for command in rush rush-pnpm rushx; do
      makeWrapper ${nodejs}/bin/node "$out/bin/$command" \
        --add-flags "$out/libexec/microsoft-rush/bin/$command"
    done

    runHook postInstall
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      inherit (finalAttrs) version;
      command = "HOME=$TMPDIR rush --help";
    };
    updateScript = ./update.sh;
  };

  meta = {
    description = "Scalable monorepo manager for the web";
    homepage = "https://rushjs.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nilathedragon ];
    inherit (nodejs.meta) platforms;
    mainProgram = "rush";
  };
})
