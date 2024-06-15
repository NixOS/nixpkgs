{ lib
, stdenv
, fetchFromGitHub
, pnpm_8
, nodejs
, npmHooks
, makeBinaryWrapper
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

  pnpmDeps = pnpm_8.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-W25xehcxncBs9QgQBt17F5YHK0b+GDEmt27XzTkyYWg=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_8.configHook
    npmHooks.npmBuildHook
    makeBinaryWrapper
  ];
  npmBuildScript = "compile";
  # We are only interested in the bash-language-server executable, which is
  # part of the `./server` directory. From some reason, the `./vscode-client`
  # directory is not included in upstream's `pnpm-workspace.yaml`, so perhaps
  # that's why our ${pnpmDeps} don't include the dependencies required for it.
  preBuild = ''
    rm -r vscode-client
    substituteInPlace tsconfig.json \
      --replace-fail '{ "path": "./vscode-client" },' ""
  '';

  installPhase = ''
    runHook preInstall

    pnpm --offline \
      --frozen-lockfile --ignore-script \
      --filter=bash-language-server \
      deploy $out/lib/bash-language-server
    # Cleanup directory a bit, to save space, and make fixup phase a bit faster
    rm -r $out/lib/bash-language-server/src
    find $out/lib/bash-language-server -name '*.ts' -delete
    rm -r \
      $out/lib/bash-language-server/node_modules/.bin \
      $out/lib/bash-language-server/node_modules/*/bin

    # Create the executable, based upon what happens in npmHooks.npmInstallHook
    makeWrapper ${lib.getExe nodejs} $out/bin/bash-language-server \
      --inherit-argv0 \
      --add-flags $out/lib/bash-language-server/out/cli.js

    runHook postInstall
  '';

  meta = with lib; {
    description = "A language server for Bash";
    homepage = "https://github.com/bash-lsp/bash-language-server";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
    mainProgram = "bash-language-server";
    platforms = platforms.all;
  };
})
