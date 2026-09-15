{
  lib,
  callPackage,
  clang_20,
  fetchFromGitHub,
  jq,
  libsecret,
  makeWrapper,
  nodejs,
  pkg-config,
  python3,
  stdenv,
  versionCheckHook,
  xcbuild,
  yarn-berry_4,
}:
let
  inherit (callPackage ./version.nix { })
    changelog
    src
    version
    yarn
    ;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "graphql-language-service-cli";
  inherit version;

  src = fetchFromGitHub {
    owner = "graphql";
    repo = "graphiql";
    inherit (src) rev hash;
  };

  patches = [
    ./patches/0001-repurpose-vscode-graphql-build-script.patch
  ];

  inherit (yarn) missingHashes;
  offlineCache = yarn-berry_4.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    inherit (yarn) hash;
  };

  nativeBuildInputs = [
    (python3.withPackages (ps: [ ps.setuptools ])) # node-gyp
    jq
    makeWrapper
    nodejs
    yarn-berry_4
    yarn-berry_4.yarnBerryConfigHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
    libsecret
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    xcbuild
    clang_20 # clang_21 breaks @vscode/vsce's optional dependency keytar
  ];

  env = {
    CYPRESS_INSTALL_BINARY = 0;
  };

  buildPhase = ''
    npm run tsc -b packages/graphql-language-service-cli/
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}

    pushd packages/graphql-language-service-cli

    node esbuild.js --minify

    mv out/graphql.js $out/lib
    # copy package.json for --version command
    jq '.version |= "${version}"' package.json > $out/lib/package.json

    makeWrapper ${lib.getExe nodejs} $out/bin/graphql-lsp \
      --add-flags $out/lib/graphql.js \

    popd

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";

  passthru = {
    updateScript = ./update.py;
  };

  meta = {
    description = "Official, runtime independent Language Service for GraphQL";
    homepage = "https://github.com/graphql/graphiql";
    inherit changelog;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nathanregner ];
    mainProgram = "graphql-lsp";
  };
})
