{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm_10,
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
  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    hash = "sha256-NvyqPv5OKgZi3hW98Da8LhsYatmrzrPX8kLOfLr+BrI=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_10.configHook
    makeBinaryWrapper
    versionCheckHook
  ];
  buildPhase = ''
    runHook preBuild

    pnpm compile server

    runHook postBuild
  '';

  # will be fixed in a later commit
  dontCheckForBrokenSymlinks = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/bash-language-server}
    cp -r {node_modules,server} $out/lib/bash-language-server/

    # Create the executable, based upon what happens in npmHooks.npmInstallHook
    makeWrapper ${lib.getExe nodejs} $out/bin/bash-language-server \
      --suffix PATH : ${lib.makeBinPath [ shellcheck ]} \
      --inherit-argv0 \
      --add-flags $out/lib/bash-language-server/server/out/cli.js

    runHook postInstall
  '';

  doInstallCheck = true;

  meta = with lib; {
    description = "Language server for Bash";
    homepage = "https://github.com/bash-lsp/bash-language-server";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
    mainProgram = "bash-language-server";
    platforms = platforms.all;
  };
})
