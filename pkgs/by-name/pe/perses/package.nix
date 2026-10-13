{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchNpmDeps,
  fetchurl,
  buildGoModule,
  npmHooks,
  nodejs,
  turbo,
  linkFarm,
  installShellFiles,
  nixosTests,
}:

let
  # Create a plugins-archive to be embedded into the perses package similar to
  # what $src/scripts/install_plugin.go does
  pluginsArchive = linkFarm "perses-plugin-archive" (
    lib.mapAttrsToList (name: plugin: {
      name = "${name}-${plugin.version}.tar.gz";
      path = fetchurl {
        inherit (plugin) url hash;
      };
    }) (import ./plugins.nix)
  );

in
buildGoModule (finalAttrs: {
  pname = "perses";
  version = "0.54.0";

  src = fetchFromGitHub {
    owner = "perses";
    repo = "perses";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6RkRL0L2ydKujk0J5hXOrL8ju0g6y0EScehXL4zdrss=";
  };

  outputs = [
    "out"
    "cue"
  ];

  nativeBuildInputs = [
    npmHooks.npmConfigHook
    nodejs
    turbo
    installShellFiles
  ];

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) version src;
    pname = "${finalAttrs.pname}-ui";
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.npmRoot}";
    hash = "sha256-KjOQgR9LcRzMijeOKdXmjIwRMwxr0kZGmZI2RQ9+u6U=";
  };

  npmRoot = "ui";

  overrideModAttrs = oldAttrs: {
    nativeBuildInputs = lib.remove npmHooks.npmConfigHook oldAttrs.nativeBuildInputs;
    preBuild = null;
  };

  vendorHash = "sha256-vMHIdKGplPQ8opnPJbVp2034KoIid0VYT4WDbj7a6sg=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/prometheus/common/version.Version=${finalAttrs.version}"
    "-X github.com/prometheus/common/version.Revision=${finalAttrs.src.tag}"
    "-X github.com/prometheus/common/version.Branch=${finalAttrs.src.tag}"
    "-X github.com/prometheus/common/version.Date=1970-01-01"
    "-X github.com/perses/perses/pkg/model/api/config.DefaultPluginPath=/run/perses/plugins"
    "-X github.com/perses/perses/pkg/model/api/config.DefaultArchivePluginPath=${pluginsArchive}"
  ];

  subPackages = [
    "cmd/percli"
    "cmd/perses"
  ];

  prePatch = ''
    patchShebangs .
  '';

  preBuild = ''
    # Since @rspack/cli 2.x the CLI shim is installed in the workspace-level
    # node_modules (ui/app/node_modules), which npmConfigHook's shebang
    # patching (scoped to ui/node_modules) does not cover.
    patchShebangs "$npmRoot"

    pushd "$npmRoot"
    npm run build
    popd

    go generate ./internal/api

    ./scripts/compress_assets.sh
  '';

  postInstall = ''
    cp -r cue "$cue"
  ''
  + (lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd percli \
      --bash <($out/bin/percli completion bash) \
      --zsh <($out/bin/percli completion zsh) \
      --fish <($out/bin/percli completion fish)
  '');

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/percli help > /dev/null

    $out/bin/perses --help 2> /dev/null

    runHook postInstallCheck
  '';

  passthru = {
    updateScript = ./update.sh;

    tests.nixos = nixosTests.perses;

    inherit pluginsArchive;
  };

  meta = {
    description = "CNCF sandbox for observability visualisation";
    homepage = "https://perses.dev/";
    changelog = "https://github.com/perses/perses/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      fooker
      byteflavour
    ];
    platforms = lib.platforms.unix;
    mainProgram = "perses";
  };
})
