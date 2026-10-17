{
  fetchFromGitHub,
  lib,
  nodejs-slim,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpmBuildHook,
  stdenvNoCC,
  nix-update-script,
  runCommand,
  stylelint-lsp,
}:
let
  pnpm = pnpm_11;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "stylelint-lsp";
  version = "2.0.1-unstable-2026-07-19";

  src = fetchFromGitHub {
    owner = "bmatcuk";
    repo = "stylelint-lsp";
    rev = "0362a26ffaf1879b9ec02e2a52a11792a2d4f8d4";
    hash = "sha256-qRc67tvgncERh6FDJdydN6aL/a5bVSsQQir3KPp1cFk=";
  };

  nativeBuildInputs = [
    nodejs-slim
    pnpmConfigHook
    pnpmBuildHook
    pnpm
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-EuCvuErydwe2LGG62VHcZtN/51Gv1uhhBN3/sEiqzME=";
  };

  preInstall = ''
    # remove unnecessary files
    CI=true pnpm --ignore-scripts prune --prod
    rm -rf node_modules/.pnpm/typescript*
    find -type f \( -name "*.ts" -o -name "*.map" \) -exec rm -rf {} +
    # https://github.com/pnpm/pnpm/issues/3645
    find node_modules -xtype l -delete
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/stylelint-lsp}
    mv {dist,node_modules} $out/lib/stylelint-lsp

    chmod a+x $out/lib/stylelint-lsp/dist/index.js
    patchShebangs $out/lib/stylelint-lsp/dist/index.js
    ln -s $out/lib/stylelint-lsp/dist/index.js $out/bin/stylelint-lsp

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version=branch" ];
    };

    tests.smoke = runCommand "stylelint-lsp-smoke-test" { } ''
      INIT_REQUEST='{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"processId":null,"rootUri":"file:///tmp","workspaceFolders":[{"uri":"file:///tmp","name":"test"}],"capabilities":{}}}'
      CONTENT_LENGTH=''${#INIT_REQUEST}

      RESPONSE=$(
        {
          printf "Content-Length: %d\r\n\r\n%s" "$CONTENT_LENGTH" "$INIT_REQUEST"
          sleep 1
        } | timeout 3  ${lib.getExe stylelint-lsp} --stdio 2>&1 | head -c 1000
      ) || true

      echo "$RESPONSE" | grep -q '"capabilities"'
      touch $out
    '';
  };

  meta = {
    description = "Stylelint Language Server";
    homepage = "https://github.com/bmatcuk/stylelint-lsp";
    license = lib.licenses.mit;
    mainProgram = "stylelint-lsp";
    maintainers = with lib.maintainers; [
      gepbird
    ];
    platforms = lib.platforms.unix;
  };
})
