{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm,
  nodejs,
  makeBinaryWrapper,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "svelte-check";
  version = "4.3.1";

  src = fetchFromGitHub {
    owner = "sveltejs";
    repo = "language-tools";
    tag = "svelte-check-${finalAttrs.version}";
    hash = "sha256-+KDl7tTyXo6QMQpMGA4hSChDaPrfqfVKJXGunTlo9Rg=";
  };

  pnpmWorkspaces = [ "svelte-check..." ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    fetcherVersion = 2;
    hash = "sha256-3bsY31sp5hjTYhRiZniAMVb3kZ1EqOlbyOvljU8jHlY=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
    makeBinaryWrapper
  ];

  buildPhase = ''
    runHook preBuild

    pnpm run --filter=svelte-check... build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    pnpm install --filter=svelte-check... --frozen-lockfile --offline --force --ignore-scripts
    mkdir -p $out/lib/node_modules/svelte-check/
    mkdir -p $out/bin

    mv {packages,node_modules} $out/lib/node_modules/svelte-check/

    makeWrapper ${lib.getExe nodejs} $out/bin/svelte-check \
      --add-flags "$out/lib/node_modules/svelte-check/packages/svelte-check/bin/svelte-check" \
      --set NODE_PATH "$out/lib/node_modules/svelte-check/packages/svelte-check/node_modules/"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--use-github-releases"
      "--version-regex"
      "svelte-check-(.*)"
    ];
  };

  meta = {
    description = "Svelte code checker";
    downloadPage = "https://www.npmjs.com/package/svelte-check";
    homepage = "https://github.com/sveltejs/language-tools";
    license = lib.licenses.mit;
    mainProgram = "svelte-check";
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
