{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
}:
buildNpmPackage (finalAttrs: {
  pname = "serve";
  version = "14.2.6";

  src = fetchFromGitHub {
    owner = "vercel";
    repo = "serve";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lM04fuzgcLHz8/Jf4wJVYXveFcO6sFyJ9PQAcpweyjk=";
  };

  # This fails during `npmInstallHook` without patching
  postPatch = ''
    substituteInPlace package.json \
      --replace-fail "prepare" "dont-prepare"
  '';

  npmDeps = null;
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 4;
    hash = "sha256-9gejKf+GqB8BPAQtQSuZsTb6jFro3X1aL1noVfyKTPg=";
  };

  nativeBuildInputs = [ pnpm_10 ];
  npmConfigHook = pnpmConfigHook;

  npmBuildScript = "compile";
  dontNpmBuild = false;

  # Use pnpm to prune deps instead
  dontNpmPrune = true;

  preInstall = ''
    CI=true pnpm prune --prod --ignore-scripts
    # Clean up broken symlinks left behind by `pnpm prune`
    # https://github.com/pnpm/pnpm/issues/3645
    find node_modules -xtype l -delete
  '';

  meta = {
    description = "Static file serving and directory listing";
    homepage = "https://github.com/vercel/serve";
    downloadPage = "https://github.com/vercel/serve/releases";
    changelog = "https://github.com/vercel/serve/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prince213 ];
    mainProgram = "serve";
  };
})
