{ lib
, fetchYarnDeps
, fetchFromGitHub
, nodejs
, typescript
, yarnConfigHook
, makeBinaryWrapper
, runCommand
, angular-language-server
, writeShellApplication
, curl
, common-updater-scripts
, jq
, gnused
, pcre
, gawk
, bazel_5
, buildBazelPackage
, pnpm_8
,
}:

buildBazelPackage rec {
  pname = "angular-language-server";
  version = "18.2.0";
  src = fetchFromGitHub {
    owner = "angular";
    repo = "vscode-ng-language-service";
    rev = "refs/tags/v${version}";
    hash = "sha256-9+WWKvy/Vu4k0BzJwPEme+9+eDPI1QP0+Ds1CbErCN8=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-N0N0XbNQRN7SHkilzo/xNlmn9U/T/WL5x8ttTqUmXl0=";
  };

  pnpmDeps = pnpm_8.fetchDeps {
    inherit pname version src;
    hash = "sha256-NOKElUu5LBzachxmdiOU2gbJBy65aEqyBAWFaqg8AXk=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    nodejs
    makeBinaryWrapper
    #pnpm_8.configHook
  ];

  buildInputs = [ typescript ];

  bazel = bazel_5;

  fetchAttrs = {
    hash = "sha256-NOKElUu5LBzachxmdiOU2gbJBy65aEqyBAWFaqg8AXk=";
  };

  bazelTargets = [ ":npm" ];

  postPatch = ''
    bazel --version | cut -c 7-11 > .bazelversion
    cat >> BUILD.bazel << EOF
    load("@rules_nodejs//nodejs:toolchain.bzl", "nodejs_toolchain")
    nodejs_toolchain(
      name = "nix-node-toolchain",
      node_path = "${nodejs}/bin/node",
    )
    toolchain(
      name = "nix_nodejs",
      exec_compatible_with = [
        "@platforms//os:linux",
      ],
      toolchain = ":nix-node-toolchain",
      toolchain_type = "@rules_nodejs//nodejs:toolchain_type",
    )
    EOF

    substituteInPlace WORKSPACE \
      --replace-fail 'nodejs_register_toolchains(
        name = "nodejs",
        node_version = "18.13.0",
    )' 'register_toolchains("//:nix_nodejs")' \
      --replace-fail 'load("@rules_nodejs//nodejs:repositories.bzl", "nodejs_register_toolchains")' ""

    cat WORKSPACE | grep "nodejs"
  '';

  buildAttrs = {

    preBuild = ''
      echo "running preBuild"
      tsc -b
      ls -la
    '';

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
  };

  passthru = {
    tests = {
      start-ok = runCommand "${pname}-test" { } ''
        ${angular-language-server}/bin/ngserver --stdio --help &> $out
        cat $out | grep "Angular Language Service that implements the Language Server Protocol (LSP)"
      '';
    };

    updateScript =
      let
        pkgFile = builtins.toString ./package.nix;
      in
      lib.getExe (writeShellApplication {
        name = "update-${pname}";
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
            -Ls https://api.github.com/repos/${src.owner}/${src.repo}/releases/latest | \
            jq -r .tag_name | cut -c 2-)
            update-source-version ${pname} "$LATEST_VERSION"
            # match from line 32 on (index starts at 0) to avoid replacing the src hash
            sed -i '31,/hash *= *"[^"]*"/{s/hash = "[^"]*"/hash = ""/}' ${pkgFile}

            echo -e "\nFetching yarn dependencies This may take a while ..."
            nix-build -A ${pname} 2> ${pname}-stderr.log || true
            NEW_YARN_HASH=$(grep "got:" ${pname}-stderr.log | awk '{print ''$2}')
            rm ${pname}-stderr.log
            # escaping double quotes looks ugly but is needed for variable substitution
            # use # instead of / as separator because the sha256 might contain the / character
            sed -i "31,/hash *= *\"[^\"]*\"/{s#hash = \"[^\"]*\"#hash = \"$NEW_YARN_HASH\"#}" ${pkgFile}
        '';
      });
  };

  meta = {
    description = "LSP for angular completions, AOT diagnostic, quick info and go to definitions";
    homepage = "https://github.com/angular/vscode-ng-language-service";
    changelog = "https://github.com/angular/vscode-ng-language-service/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "ngserver";
    maintainers = with lib.maintainers; [ tricktron ];
  };
}
