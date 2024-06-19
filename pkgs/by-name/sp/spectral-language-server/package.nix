{ lib
, buildNpmPackage
, mkYarnPackage
, fetchYarnDeps
, fetchFromGitHub
, typescript
, jq
, fetchpatch
}:
let
  # Instead of the build script that spectral-language-server provides (ref: https://github.com/luizcorreia/spectral-language-server/blob/master/script/vscode-spectral-build.sh), we build vscode-spectral manually.
  # This is because the script must go through the network and will not work under the Nix sandbox environment.
  vscodeSpectral = mkYarnPackage rec {
    pname = "vscode-spectral";
    version = "1.1.2";

    src = fetchFromGitHub {
      owner = "stoplightio";
      repo = "vscode-spectral";
      rev = "v${version}";
      hash = "sha256-TWy+bC6qhTKDY874ORTBbvCIH8ycpmBiU8GLYxBIiAs=";
    };

    packageJSON = ./package.json;

    offlineCache = fetchYarnDeps {
      yarnLock = src + "/yarn.lock";
      hash = "sha256-am27A9VyFoXuOlgG9mnvNqV3Q7Bi7GJzDqqVFGDVWIA=";
    };

    nativeBuildInputs = [ typescript jq ];

    postPatch = ''
      cp server/tsconfig.json server/tsconfig.json.bak
      jq '.compilerOptions += {"module": "NodeNext", "moduleResolution": "NodeNext"}' server/tsconfig.json.bak > server/tsconfig.json
    '';

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild
      # FIXME: vscode-spactral depends on @rollup/pluginutils, but it may have a bug that doesn't provide the type definitions for NodeNext module resolution. (ref: https://github.com/rollup/plugins/issues/1192)
      # tsc detects some type errors in the code. However we ignore this because it's not a problem for the final build if server/dist is generated.
      tsc -p server || true
      test -d server/dist
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -R server/dist $out
      runHook postInstall
    '';

    doDist = false;

    meta = with lib; {
      homepage = "https://github.com/stoplightio/vscode-spectral";
      description = "VS Code extension bringing the awesome Spectral JSON/YAML linter with OpenAPI/AsyncAPI support";
      license = licenses.asl20;
    };
  };
in
buildNpmPackage rec {
  pname = "spectral-language-server";
  version = "1.0.8-unstable-2023-06-06";

  src = fetchFromGitHub {
    owner = "luizcorreia";
    repo = "spectral-language-server";
    rev = "c9a7752b08e6bba937ef4f5435902afd41b6957f";
    hash = "sha256-VD2aAzlCnJ6mxPUSbNRfMOlslM8kLPqrAI2ah6sX9cU=";
  };

  npmDepsHash = "sha256-ixAXy/rRkyWL3jdAkrXJh1qhWcKIkr5nH/Bhu2JV6k8=";

  patches = [
    # https://github.com/luizcorreia/spectral-language-server/pull/15
    (fetchpatch {
      name = "fix-package-lock.patch";
      url = "https://github.com/luizcorreia/spectral-language-server/commit/909704850dd10e7b328fc7d15f8b07cdef88899d.patch";
      hash = "sha256-+mN93xP4HCll4dTcnh2W/m9k3XovvgnB6AOmuJpZUZ0=";
    })
  ];

  dontNpmBuild = true;

  npmFlags = [ "--ignore-scripts" ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mkdir -p $out/node_modules
    mkdir -p $out/dist/spectral-language-server
    cp -R ${vscodeSpectral}/dist/* $out/dist/spectral-language-server/
    cp ./bin/* $out/bin
    cp -R ./node_modules/* $out/node_modules
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/luizcorreia/spectral-language-server";
    description = "Awesome Spectral JSON/YAML linter with OpenAPI/AsyncAPI support";
    maintainers = with maintainers; [ momeemt ];
    license = licenses.mit;
    mainProgram = "spectral-language-server";
  };
}
