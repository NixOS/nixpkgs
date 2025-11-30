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
  pname = "svelte-language-server";
  version = "0.17.21";

  src = fetchFromGitHub {
    owner = "sveltejs";
    repo = "language-tools";
    tag = "svelte-language-server@${finalAttrs.version}";
    hash = "sha256-HNd4M7bFTN0oFdO44w8Rgz45mDLrJ/ksZKB0iPw6t1s=";
  };

  pnpmWorkspaces = [ "svelte-language-server..." ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    fetcherVersion = 2;
    hash = "sha256-J279yrHRyG6QyUedXmYwv6Kcuz/9pGwvu6dUELIFeu8=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
    makeBinaryWrapper
  ];

  buildPhase = ''
    runHook preBuild

    pnpm run --filter=svelte-language-server... build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    pnpm install --filter=svelte-language-server... --prod --frozen-lockfile --offline --force --ignore-scripts
    mkdir -p $out/lib/node_modules/svelte-language-server/
    mkdir -p $out/bin

    mv {packages,node_modules} $out/lib/node_modules/svelte-language-server/

    makeWrapper ${lib.getExe nodejs} $out/bin/svelteserver \
      --add-flags "$out/lib/node_modules/svelte-language-server/packages/language-server/bin/server.js" \
      --set NODE_PATH "$out/lib/node_modules/svelte-language-server/packages/language-server/node_modules/"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--use-github-releases"
      "--version-regex"
      "svelte-language-server@(.*)"
    ];
  };

  meta = {
    description = "Language server (implementing the language server protocol) for Svelte";
    downloadPage = "https://www.npmjs.com/package/svelte-language-server";
    homepage = "https://github.com/sveltejs/language-tools";
    license = lib.licenses.mit;
    mainProgram = "svelteserver";
    maintainers = [ ];
  };
})
