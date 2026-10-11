{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  makeWrapper,
  nix-update-script,
  nodejs,
  runCommand,
  stylelint-language-server,
}:

buildNpmPackage (finalAttrs: {
  pname = "stylelint-language-server";
  version = "1.1.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = "vscode-stylelint";
    tag = "@stylelint/language-server@${finalAttrs.version}";
    hash = "sha256-QRFc//mG7e0G7A7ZmwQzakU7RvegTPaJ6pGzvan2mwQ=";
  };

  npmWorkspace = "packages/language-server";
  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-+h7+c4zrS3UlssAYvcovkHEsyfJsBXruZFAEDv1Xro0=";

  npmInstallFlags = [
    "--workspace=packages/language-server"
    "--include-workspace-root=false"
  ];

  npmPruneFlags = [
    "--workspace=packages/language-server"
    "--include-workspace-root=false"
  ];

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    npm prune --omit=dev --workspace=packages/language-server --include-workspace-root=false

    mkdir -p $out/bin $out/lib/stylelint-language-server/packages
    cp -r node_modules $out/lib/stylelint-language-server
    cp -r packages/language-server $out/lib/stylelint-language-server/packages

    makeWrapper ${nodejs}/bin/node $out/bin/stylelint-language-server \
      --add-flags "$out/lib/stylelint-language-server/packages/language-server/bin/stylelint-language-server.mjs"

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--use-github-releases"
        "--version-regex"
        "@stylelint/language-server@(.*)"
      ];
    };

    tests.smoke = runCommand "stylelint-language-server-smoke-test" { } ''
      INIT_REQUEST='{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"processId":null,"rootUri":"file:///tmp","workspaceFolders":[{"uri":"file:///tmp","name":"test"}],"capabilities":{}}}'
      CONTENT_LENGTH=''${#INIT_REQUEST}

      RESPONSE=$(
        {
          printf "Content-Length: %d\\r\\n\\r\\n%s" "$CONTENT_LENGTH" "$INIT_REQUEST"
          sleep 1
        } | timeout 3 ${lib.getExe stylelint-language-server} --stdio 2>&1 | head -c 1000
      ) || true

      echo "$RESPONSE" | grep -q '"capabilities"'
      touch $out
    '';
  };

  meta = {
    description = "Official Stylelint language server";
    homepage = "https://github.com/stylelint/vscode-stylelint";
    license = lib.licenses.mit;
    mainProgram = "stylelint-language-server";
    maintainers = with lib.maintainers; [ tyceherrman ];
  };
})
