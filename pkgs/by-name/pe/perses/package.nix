{
  lib,
  fetchFromGitHub,
  fetchNpmDeps,
  fetchurl,
  buildGoModule,
  npmHooks,
  nodejs,
  turbo,
  linkFarm,
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
  version = "0.51.0";

  src = fetchFromGitHub {
    owner = "perses";
    repo = "perses";
    tag = "v${finalAttrs.version}";
    hash = "sha256-frCSuGEnYab4CTQoAuN876dG7Mwn/RJEnWouUuo7aJQ=";
  };

  outputs = [
    "out"
    "cue"
  ];

  nativeBuildInputs = [
    npmHooks.npmConfigHook
    nodejs
    turbo
  ];

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) version src;
    pname = "${finalAttrs.pname}-ui";
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.npmRoot}";
    hash = "sha256-nRE4IV8+wCuYXNAxrl7RfBFdY/ZyAIpXs3pDfCeIh74=";
  };

  npmRoot = "ui";

  overrideModAttrs = oldAttrs: {
    nativeBuildInputs = lib.remove npmHooks.npmConfigHook oldAttrs.nativeBuildInputs;
    preBuild = null;
  };

  vendorHash = "sha256-FfT3z48JaOiUTsVMmcbJdFJesO7cIMkYt/0gQ0jHh8I=";

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
    pushd "$npmRoot"
    npm run build
    popd

    go generate ./internal/api

    ./scripts/compress_assets.sh
  '';

  postInstall = ''
    cp -r cue "$cue"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/percli help > /dev/null

    $out/bin/perses --help 2> /dev/null

    runHook postInstallCheck
  '';

  passthru = {
    updateScript = ./update.sh;

    inherit pluginsArchive;
  };

  meta = {
    description = "CNCF sandbox for observability visualisation";
    homepage = "https://perses.dev/";
    changelog = "https://github.com/perses/perses/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fooker ];
    platforms = lib.platforms.unix;
    mainProgram = "perses";
  };
})
