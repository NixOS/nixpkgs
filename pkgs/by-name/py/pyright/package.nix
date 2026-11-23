{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpm_11,
  pnpmConfigHook,
  nodejs,
  makeBinaryWrapper,
  nix-update-script,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pyright";
  version = "1.1.415";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = "pyright";
    tag = finalAttrs.version;
    hash = "sha256-C8JTkD2Co4sd7pzabBe45sWLgL/rowBpfGrHgxVXvLs=";
  };

  pnpmWorkspaces = [
    "pyright-root"
    "pyright-internal"
    "pyright"
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    pnpm = pnpm_11;
    fetcherVersion = 4;
    hash = "sha256-juei/EB2z5h2t1l2aocxuWY8WLfh/gxNKDI5ZB3h9PM=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_11
    pnpmConfigHook
    makeBinaryWrapper
  ];

  buildPhase = ''
    runHook preBuild

    pnpm --filter pyright build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/pyright"
    cp -r packages/pyright/{dist,index.js,langserver.index.js,package.json} "$out/lib/pyright/"
    cp LICENSE.txt README.md "$out/lib/pyright/"

    makeWrapper ${lib.getExe nodejs} "$out/bin/pyright" \
      --add-flags "$out/lib/pyright/index.js"
    makeWrapper ${lib.getExe nodejs} "$out/bin/pyright-langserver" \
      --add-flags "$out/lib/pyright/langserver.index.js"

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
  };

  meta = {
    changelog = "https://github.com/Microsoft/pyright/releases/tag/${finalAttrs.src.tag}";
    description = "Type checker for the Python language";
    homepage = "https://github.com/Microsoft/pyright";
    license = lib.licenses.mit;
    mainProgram = "pyright";
    maintainers = with lib.maintainers; [ kalekseev ];
    platforms = nodejs.meta.platforms;
  };
})
