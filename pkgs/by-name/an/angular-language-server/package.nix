{
  lib,
  stdenvNoCC,
  fetchYarnDeps,
  fetchFromGitHub,
  nodejs,
  typescript,
  yarnConfigHook,
  yarnBuildHook,
  makeBinaryWrapper,
  runCommand,
  angular-language-server,
  writeShellApplication,
  curl,
  common-updater-scripts,
  jq,
  gnused,
  pcre,
  gawk,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "angular-language-server";
  version = "18.2.0";
  src = fetchFromGitHub {
    owner = "angular";
    repo = "vscode-ng-language-service";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-9+WWKvy/Vu4k0BzJwPEme+9+eDPI1QP0+Ds1CbErCN8=";
  };
  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-N0N0XbNQRN7SHkilzo/xNlmn9U/T/WL5x8ttTqUmXl0=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
    makeBinaryWrapper
  ];

  buildInputs = [ typescript ];

  yarnBuildScript = "compile";

  installPhase = ''
    runHook preInstall
    install -Dm755 bazel-bin/vsix_sandbox/server/bin/ngserver $out/bin/ngserver
    install -Dm755 bazel-bin/vsix_sandbox/server/index.js $out/index.js
    cp -r bazel-bin/vsix_sandbox/node_modules $out/node_modules
    runHook postInstall
  '';

  postFixup = ''
    patchShebangs $out/bin/ngserver
    patchShebangs $out/index.js
    patchShebangs $out/node_modules
    wrapProgram $out/bin/ngserver \
      --add-flags "--tsProbeLocations $out/node_modules --ngProbeLocations $out/node_modules"
  '';

  passthru = {
    tests = {
      start-ok = runCommand "${finalAttrs.pname}-test" { } ''
        ${angular-language-server}/bin/ngserver --stdio --help &> $out
        cat $out | grep "Angular Language Service that implements the Language Server Protocol (LSP)"
      '';
    };

    updateScript =
      let
        pkgFile = builtins.toString ./package.nix;
      in
      lib.getExe (writeShellApplication {
        name = "update-${finalAttrs.pname}";
        runtimeInputs = [
          curl
          pcre
          common-updater-scripts
          jq
          gnused
          gawk
        ];
        text = ''
          LATEST_VERSION=$(curl -H "Accept: application/vnd.github+json" \
            -Ls https://api.github.com/repos/${finalAttrs.src.owner}/${finalAttrs.src.repo}/releases/latest | \
            jq -r .tag_name | cut -c 2-)
            update-source-version ${finalAttrs.pname} "$LATEST_VERSION"
            # match from line 32 on (index starts at 0) to avoid replacing the src hash
            sed -i '31,/hash *= *"[^"]*"/{s/hash = "[^"]*"/hash = ""/}' ${pkgFile}

            echo -e "\nFetching yarn dependencies This may take a while ..."
            nix-build -A ${finalAttrs.pname} 2> ${finalAttrs.pname}-stderr.log || true
            NEW_YARN_HASH=$(grep "got:" ${finalAttrs.pname}-stderr.log | awk '{print ''$2}')
            rm ${finalAttrs.pname}-stderr.log
            # escaping double quotes looks ugly but is needed for variable substitution
            # use # instead of / as separator because the sha256 might contain the / character
            sed -i "31,/hash *= *\"[^\"]*\"/{s#hash = \"[^\"]*\"#hash = \"$NEW_YARN_HASH\"#}" ${pkgFile}
        '';
      });
  };

  meta = {
    description = "LSP for angular completions, AOT diagnostic, quick info and go to definitions";
    homepage = "https://github.com/angular/vscode-ng-language-service";
    changelog = "https://github.com/angular/vscode-ng-language-service/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "ngserver";
    maintainers = with lib.maintainers; [ tricktron ];
  };
})
