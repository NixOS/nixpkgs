{
  lib,
  stdenv,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  jq,
  fetchFromGitHub,
  fetchPnpmDeps,
  makeWrapper,
  nix-update-script,
  versionCheckHook,
  git,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "difit";
  version = "3.1.10";

  src = fetchFromGitHub {
    owner = "yoshiko-pg";
    repo = "difit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Yr7x8NJJP3X8YP5tGNMmn4mUxrmz3RMvnx9MPz4jj7o=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-IRCr/Fo0lgv+JSMIYrTpyWgGA6EORCNL+igK88dkJNg=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_10
    jq
    makeWrapper
  ];

  postPatch = ''
    # Remove prepare script (lefthook install) since we don't need git hooks
    jq 'del(.scripts.prepare)' package.json > package.json.tmp
    mv package.json.tmp package.json
  '';

  buildPhase = ''
    runHook preBuild
    pnpm build
    pnpm prune --prod
    # Clean up broken symlinks left behind by pnpm prune
    find node_modules -xtype l -delete
    # Remove non-deterministic files
    rm -f node_modules/.modules.yaml
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    appdir="$out/lib/difit"
    mkdir -p "$appdir" "$out/bin"

    cp -r dist node_modules package.json "$appdir"/

    makeWrapper ${nodejs}/bin/node "$out/bin/difit" \
      --add-flags "$appdir/dist/cli/index.js" \
      --set NODE_PATH "$appdir/node_modules" \
      --prefix PATH : ${lib.makeBinPath [ git ]}

    # Install agent skill file for AI coding assistants
    install -Dm644 SKILL.md "$out/share/difit/SKILL.md"

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool to view local git diffs in a GitHub-style web viewer";
    homepage = "https://github.com/yoshiko-pg/difit";
    changelog = "https://github.com/yoshiko-pg/difit/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "difit";
    maintainers = with lib.maintainers; [ poelzi ];
  };
})
