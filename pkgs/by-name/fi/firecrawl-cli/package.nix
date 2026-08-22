{
  lib,
  stdenvNoCC,

  fetchFromGitHub,
  fetchPnpmDeps,

  makeWrapper,
  nodejs,
  pnpm_11,
  pnpmConfigHook,

  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "firecrawl-cli";
  version = "1.21.1";
  __structuredAttrs = true;
  strictDeps = true;

  outputs = [
    "out"
    "skills"
  ];

  src = fetchFromGitHub {
    owner = "firecrawl";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zFtXf+3vj/xcodCTbyEvQsNqNqnnnOvnrWFn65+heS0=";
  };

  patches = [
    ./default-disable-telemetry.patch
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_11;
    fetcherVersion = 4;
    hash = "sha256-R59OM/4zZF3+JGMG3URe60I+Vs5x9WPeQfuZjuHDodc=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    pnpmConfigHook
    pnpm_11
  ];

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/firecrawl-cli

    # `pnpm build` doesn't bundle dependencies so we'll need to keep node_modules
    # - remove unnecessary files
    CI=true pnpm --ignore-scripts --prod prune
    find -type f \( -name "*.ts" -o -name "*.map" \) -exec rm -rf {} +
    # https://github.com/pnpm/pnpm/issues/3645
    find node_modules -xtype l -delete
    # - copy over node modules
    cp -r dist node_modules $out/lib/firecrawl-cli
    cp package.json $out/lib/firecrawl-cli

    cp -r skills $skills
    ln -s $skills $out/lib/firecrawl-cli/skills

    # patch executable index.js just in-case
    patchShebangs $out/lib/firecrawl-cli/dist/index.js
    # prepare an entrypoint in /bin
    makeWrapper ${lib.getExe nodejs} "$out/bin/firecrawl" --add-flags "$out/lib/firecrawl-cli/dist/index.js"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI and Agent Skill for Firecrawl - Add scrape, search, and browsing capabilities to your AI agents";
    homepage = "https://github.com/firecrawl/cli";
    changelog = "https://github.com/firecrawl/cli/releases/tag/${finalAttrs.src.tag}";
    # https://github.com/firecrawl/cli/blob/main/package.json#L48
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jk
    ];
    mainProgram = "firecrawl";
    platforms = lib.platforms.all;
  };
})
