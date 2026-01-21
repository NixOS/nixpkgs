{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpm_8,
  nodejs,
  pnpmConfigHook,
  makeBinaryWrapper,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "caddyfile-language-server";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "caddyserver";
    repo = "vscode-caddyfile";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IusP9Z3e8mQ0mEhI1o1zIqPDB/i0pqlMfnt6M8bzb2w=";
  };

  pnpmWorkspaces = [ "@caddyserver/caddyfile-language-server" ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    pnpm = pnpm_8;
    fetcherVersion = 3;
    hash = "sha256-D9kYFkmFlvg4r6vR9PHHAwF0qglHsTuRae0Z7CzDq1M=";
  };

  nativeBuildInputs = [
    pnpm_8
    pnpmConfigHook
    nodejs
    makeBinaryWrapper
  ];

  buildPhase = ''
    runHook preBuild

    pnpm --filter=@caddyserver/caddyfile-language-server run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    rm -rf node_modules packages/server/node_modules
    pnpm install --production --offline --force --filter=@caddyserver/caddyfile-language-server
    mkdir -p $out/lib/node_modules/caddyfile-language-server/
    mv packages/server/dist/* $out/lib/node_modules/caddyfile-language-server/

    makeWrapper ${lib.getExe nodejs} $out/bin/caddyfile-language-server \
      --add-flags "$out/lib/node_modules/caddyfile-language-server/index.js"

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/caddyserver/vscode-caddyfile/releases/tag/v${finalAttrs.version}";
    description = "Basic language server for caddyfile";
    homepage = "https://github.com/caddyserver/vscode-caddyfile";
    mainProgram = "caddyfile-language-server";
    maintainers = with lib.maintainers; [ pyrox0 ];
    platforms = lib.platforms.all;
  };
})
