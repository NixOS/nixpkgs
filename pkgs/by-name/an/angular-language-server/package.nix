{
  lib,
  stdenvNoCC,
  fetchurl,
  nodejs,
  makeBinaryWrapper,
  runCommand,
  angular-language-server,
  writeShellApplication,
  curl,
  common-updater-scripts,
  jq,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "angular-language-server";
  version = "19.0.3";
  src = fetchurl {
    name = "angular-language-server-${finalAttrs.version}.zip";
    url = "https://github.com/angular/vscode-ng-language-service/releases/download/v${finalAttrs.version}/ng-template.vsix";
    hash = "sha256-QVvXwzSaj5wMYEwMMXGJwRwg7v6HdB0JKLkQiUNR0y4=";
  };

  nativeBuildInputs = [
    unzip
    makeBinaryWrapper
  ];

  buildInputs = [ nodejs ];

  installPhase = ''
    runHook preInstall
    install -Dm755 server/bin/ngserver $out/lib/bin/ngserver
    install -Dm755 server/index.js $out/lib/index.js
    cp -r node_modules $out/lib/node_modules
    runHook postInstall
  '';

  postFixup = ''
    patchShebangs $out/lib/bin/ngserver $out/lib/index.js $out/lib/node_modules
    makeWrapper $out/lib/bin/ngserver $out/bin/ngserver \
      --prefix PATH : ${lib.makeBinPath [ nodejs ]} \
      --add-flags "--tsProbeLocations $out/lib/node_modules --ngProbeLocations $out/lib/node_modules"
  '';

  passthru = {
    tests = {
      start-ok = runCommand "${finalAttrs.pname}-test" { } ''
        ${lib.getExe angular-language-server} --stdio --help &> $out
        cat $out | grep "Angular Language Service that implements the Language Server Protocol (LSP)"
      '';
    };

    updateScript = lib.getExe (writeShellApplication {
      name = "update-angular-language-server";
      runtimeInputs = [
        curl
        common-updater-scripts
        jq
      ];
      text = ''
        if [ -z "''${GITHUB_TOKEN:-}" ]; then
            echo "no GITHUB_TOKEN provided - you could meet API request limiting" >&2
        fi

        LATEST_VERSION=$(curl -H "Accept: application/vnd.github+json" \
            ''${GITHUB_TOKEN:+-H "Authorization: bearer $GITHUB_TOKEN"} \
          -Lsf https://api.github.com/repos/angular/vscode-ng-language-service/releases/latest | \
          jq -r .tag_name | cut -c 2-)
        update-source-version angular-language-server "$LATEST_VERSION"
      '';
    });
  };

  meta = {
    description = "LSP for angular completions, AOT diagnostic, quick info and go to definitions";
    homepage = "https://github.com/angular/vscode-ng-language-service";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    changelog = "https://github.com/angular/vscode-ng-language-service/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "ngserver";
    maintainers = with lib.maintainers; [ tricktron ];
  };
})
