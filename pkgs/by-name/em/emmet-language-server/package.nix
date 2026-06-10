{
  lib,
  stdenvNoCC,
  nodejs-slim,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpmBuildHook,
  fetchFromGitHub,
  nix-update-script,
  runCommand,
  emmet-language-server,
}:
let
  pnpm = pnpm_11;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "emmet-language-server";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "olrtg";
    repo = "emmet-language-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EY/xfrf6sGnZPbkbf9msauOoZ0h0EjLSwQC0aiS/Kco=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-FbwciSGn/W8xQhTU2rHdYIX01wUAqcgY67za8n5AMcM=";
  };

  nativeBuildInputs = [
    nodejs-slim
    pnpmConfigHook
    pnpmBuildHook
    pnpm
  ];

  # remove unnecessary and non-deterministic files
  preInstall = ''
    CI=true pnpm --ignore-scripts --prod prune
    find -type f \( -name "*.ts" -o -name "*.map" \) -exec rm -rf {} +
    # https://github.com/pnpm/pnpm/issues/3645
    find node_modules -xtype l -delete

    rm node_modules/.modules.yaml
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/emmet-language-server}
    mv {node_modules,dist} $out/lib/emmet-language-server

    chmod +x $out/lib/emmet-language-server/dist/index.js
    patchShebangs $out/lib/emmet-language-server/dist/index.js
    ln -s $out/lib/emmet-language-server/dist/index.js $out/bin/emmet-language-server

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };

    tests.smoke = runCommand "emmet-language-server-smoke-test" { } ''
      INIT_REQUEST='{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"processId":null,"rootUri":"file:///tmp","workspaceFolders":[{"uri":"file:///tmp","name":"test"}],"capabilities":{}}}'
      CONTENT_LENGTH=''${#INIT_REQUEST}

      RESPONSE=$(
        {
          printf "Content-Length: %d\r\n\r\n%s" "$CONTENT_LENGTH" "$INIT_REQUEST"
          sleep 1
        } | timeout 3  ${lib.getExe emmet-language-server} --stdio 2>&1 | head -c 1000
      ) || true

      echo "$RESPONSE" | grep -q '"capabilities"'
      touch $out
    '';
  };

  meta = {
    description = "Language server for emmet.io";
    homepage = "https://github.com/olrtg/emmet-language-server";
    changelog = "https://github.com/olrtg/emmet-language-server/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      gepbird
    ];
    mainProgram = "emmet-language-server";
  };
})
