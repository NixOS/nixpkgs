{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpm,
  pnpmConfigHook,
  nodejs_20,
  stdenv,
  testers,
  writeShellScript,
  gh,
  nix-update,
  common-updater-scripts,
}:
let
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "inngest";
    repo = "inngest";
    tag = "v${version}";
    hash = "sha256-r7SvSFYyoe4PMZ7MtM9aJa1yE9mV5HSGYiO/PagYMz4=";
  };

  website = fetchFromGitHub {
    owner = "inngest";
    repo = "website";
    rev = "159c0ac611e85ec85ffe0a8c8bf2c4a0330bdb38";
    hash = "sha256-EkTIv8jgcqzurz2M7PC6Kfh6x2Zxu7UmIhpTjlj8o88=";
  };

  inngest-ui = stdenv.mkDerivation (finalAttrs: {
    inherit version src;
    pname = "inngest-ui";

    nativeBuildInputs = [
      nodejs_20
      pnpm
      pnpmConfigHook
    ];

    pnpmDeps =
      (fetchPnpmDeps {
        inherit (finalAttrs) pname version src;
        sourceRoot = "${finalAttrs.src.name}/ui";
        fetcherVersion = 3;
        hash = "sha256-K7PPrv7ZkcoZCS1IqCIqeBgac0vlZNaBztXS2vJ0vAk=";
      }).overrideAttrs
        (old: {
          env = (old.env or { }) // {
            npm_config_manage_package_manager_versions = "false";
          };
        });
    pnpmRoot = "ui";

    buildPhase = ''
      runHook preBuild
      pnpm --filter dev-server-ui build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/dist
      cp -r ui/apps/dev-server-ui/dist/. $out/dist/
      runHook postInstall
    '';
  });
in
buildGoModule (finalAttrs: {
  inherit version src;
  pname = "inngest";

  __structuredAttrs = true;

  vendorHash = null;

  preBuild = ''
    cp -r ${inngest-ui}/dist/. ./pkg/devserver/static/
    cp -r ${website}/. ./internal/embeddocs/website/
  '';

  postInstall = ''
    mv $out/bin/cmd $out/bin/inngest
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/inngest/inngest/pkg/inngest/version.Version=${version}"
  ];

  env.CGO_ENABLED = 0;

  subPackages = [ "cmd/" ];

  passthru = {
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
    updateScript = writeShellScript "update-inngest" ''
      set -euo pipefail
      # exclude beta/rc tags before picking highest semver
      latest=$(${lib.getExe gh} release list --repo inngest/inngest \
        --json tagName --jq '.[].tagName' \
        | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' \
        | sort -V | tail -1 | tr -d 'v')
      ${lib.getExe nix-update} inngest --version "$latest"
      websiteRev=$(${lib.getExe gh} api \
        "repos/inngest/inngest/contents/internal/embeddocs/website?ref=v$latest" \
        --jq '.sha')
      ${common-updater-scripts}/bin/update-source-version inngest "$latest" "" \
        --source-key="website" --rev="$websiteRev" --ignore-same-version || true
    '';
  };

  meta = {
    description = "CLI and dev server for Inngest durable workflows";
    homepage = "https://github.com/inngest/inngest";
    changelog = "https://github.com/inngest/inngest/releases/tag/v${version}";
    license = lib.licenses.sspl;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = with lib.maintainers; [
      darwin67
      highjeans
      jpwilliams
      kikos0
    ];
    mainProgram = "inngest";
    platforms = lib.platforms.all;
  };
})
