{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  fetchPnpmDeps,
  makeWrapper,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "home-assistant-matter-hub";
  version = "2.0.41";

  src = fetchFromGitHub {
    owner = "RiDDiX";
    repo = "home-assistant-matter-hub";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+W0HjULERuW+RY7938xGnEXwmCpkumLpUlZmvfuhX2Y=";
  };

  # The bundled cli.js imports transitive dependencies (e.g. @noble/curves)
  # directly, so we need a flat node_modules tree for Node's resolver to
  # find them.
  pnpmInstallFlags = [ "--shamefully-hoist" ];
  pnpmWorkspaces = [ "home-assistant-matter-hub..." ];
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmInstallFlags
      pnpmWorkspaces
      ;
    fetcherVersion = 3;
    hash = "sha256-1DaR4q1QH07UR+EchfDI92bTdRY4C2IaGIRj426DURI=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  # Workspace package.json files all carry "0.0.0"; the real version is
  # injected at release time via APP_VERSION (consumed by vite for the
  # frontend bundle and by the backend at runtime).
  env.APP_VERSION = finalAttrs.version;

  nativeBuildInputs = [
    nodejs
    pnpm_10
    pnpmConfigHook
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild

    pnpm --filter home-assistant-matter-hub... run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/apps/home-assistant-matter-hub

    tar -xf apps/home-assistant-matter-hub/package.tgz \
      --strip-components=1 \
      -C $out/share/apps/home-assistant-matter-hub

    # pnpm cannot recursively prune monorepos, so we follow pnpm's
    # recommendation of removing all node_modules and reinstalling
    # only the production dependencies we need.
    find . -name node_modules -type d -prune -exec rm -rf {} +
    pnpm install --offline --prod --filter-prod home-assistant-matter-hub --shamefully-hoist

    # Workspace symlinks under apps/home-assistant-matter-hub/node_modules use
    # relative paths into the top-level node_modules/.pnpm store, so we keep
    # the original directory layout under $out/share.
    mv node_modules $out/share/
    mv apps/home-assistant-matter-hub/node_modules $out/share/apps/home-assistant-matter-hub/

    makeWrapper ${lib.getExe nodejs} "$out/bin/home-assistant-matter-hub" \
      --add-flags "$out/share/apps/home-assistant-matter-hub/dist/backend/cli.js" \
      --set NODE_ENV production \
      --set APP_VERSION ${finalAttrs.version}

    runHook postInstall
  '';

  meta = {
    description = "Publish your home-assistant instance using Matter";
    homepage = "https://riddix.github.io/home-assistant-matter-hub/";
    changelog = "https://github.com/RiDDiX/home-assistant-matter-hub/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kranzes
      marie
    ];
    mainProgram = "home-assistant-matter-hub";
    inherit (nodejs.meta) platforms;
  };
})
