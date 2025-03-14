{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm_8,
  nodejs,
  makeBinaryWrapper,
  shellcheck,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bash-language-server";
  version = "5.4.0";

  src = fetchFromGitHub {
    owner = "bash-lsp";
    repo = "bash-language-server";
    rev = "server-${finalAttrs.version}";
    hash = "sha256-yJ81oGd9aNsWQMLvDSgMVVH1//Mw/SVFYFIPsJTQYzE=";
  };

  pnpmWorkspaces = [ "bash-language-server" ];
  pnpmDeps = pnpm_8.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    hash = "sha256-W25xehcxncBs9QgQBt17F5YHK0b+GDEmt27XzTkyYWg=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_8.configHook
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
