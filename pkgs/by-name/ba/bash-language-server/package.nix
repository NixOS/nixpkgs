{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm_9,
  nodejs,
  makeBinaryWrapper,
  shellcheck,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bash-language-server";
  version = "5.6.0";

  src = fetchFromGitHub {
    owner = "bash-lsp";
    repo = "bash-language-server";
    rev = "server-${finalAttrs.version}";
    hash = "sha256-Pe32lQSlyWcyUbqwhfoulwNwhrnWdRcKFIl3Jj0Skac=";
  };

  pnpmWorkspaces = [ "bash-language-server" ];
  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    hash = "sha256-HB93H8KyVC9gdu2Cj3e95KPawsijrOH3a9A+ymYVx48=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_9.configHook
    makeBinaryWrapper
    versionCheckHook
  ];
  buildPhase = ''
    runHook preBuild

    pnpm compile server

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    pnpm --offline \
      --frozen-lockfile --ignore-script \
      --filter=bash-language-server \
      deploy --prod $out/lib/bash-language-server

    # Create the executable, based upon what happens in npmHooks.npmInstallHook
    makeWrapper ${lib.getExe nodejs} $out/bin/bash-language-server \
      --suffix PATH : ${lib.makeBinPath [ shellcheck ]} \
      --inherit-argv0 \
      --add-flags $out/lib/bash-language-server/out/cli.js

    runHook postInstall
  '';

  doInstallCheck = true;

  meta = with lib; {
    description = "A language server for Bash";
    homepage = "https://github.com/bash-lsp/bash-language-server";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
    mainProgram = "bash-language-server";
    platforms = platforms.all;
  };
})
