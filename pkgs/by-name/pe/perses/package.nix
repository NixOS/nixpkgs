{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchNpmDeps,
  fetchurl,
  buildGo127Module,
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
buildGo127Module (finalAttrs: {
  pname = "perses";
  version = "0.55.0";

  src = fetchFromGitHub {
    owner = "perses";
    repo = "perses";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6nb+gl/rKOt6+Lddj9+mu6D5Asu5dDF31wD9U2KywUw=";
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
    hash = "sha256-RGtGI1ylJCihrgg+86/aqIOE7pM+EY1i+ZvuCBmynoY=";
  };

  npmRoot = "ui";

  overrideModAttrs = oldAttrs: {
    nativeBuildInputs = lib.remove npmHooks.npmConfigHook oldAttrs.nativeBuildInputs;
    preBuild = null;
  };

  vendorHash = "sha256-ohvAxU54fMXl4PJ7aP2Puw149bV7NRwu0UHtGbYI8sU=";

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
