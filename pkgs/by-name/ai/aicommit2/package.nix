{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nodejs,
  pnpm,
  makeWrapper,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "aicommit2";
  version = "1.12.3";

  src = fetchFromGitHub {
    owner = "tak-bro";
    repo = "aicommit2";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WKegxSnw7YgSa0H0pxhQws9MgYa08x3F/Q5MIePnTY4=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-Bdwskm81i6dleC/w/zK5iKbMIwBUhCp36sll+Ei5Wd4=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
    makeWrapper
  ];
  buildInputs = [ nodejs ];

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/aicommit2}
    cp -r {dist,node_modules} $out/lib/aicommit2

    runHook postInstall
  '';

  preFixup = ''
    makeWrapper ${lib.getExe nodejs} $out/bin/aicommit2 \
    --chdir "$out/lib/aicommit2" \
    --append-flags "$out/lib/aicommit2/dist/cli.mjs"
  '';
  meta = {
    description = "Reactive CLI that generates git commit messages with AI";
    homepage = "https://github.com/tak-bro/aicommit2";
    changelog = "https://github.com/tak-bro/aicommit2/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ByteSudoer ];
    mainProgram = "aicommit2";
    platforms = lib.platforms.all;
  };
})
