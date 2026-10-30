{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  nodejs-slim,
  nixosTests,
  yarn-berry_4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "outline";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "outline";
    repo = "outline";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7S6ZqTf7DMq3YCz7400FzDIazDQ+7NUrlAMTJuHhp9w=";
  };

  missingHashes = ./missing-hashes.json;

  nativeBuildInputs = [
    makeWrapper
    nodejs-slim
    yarn-berry_4.yarnBerryConfigHook
    yarn-berry_4
  ];

  offlineCache = yarn-berry_4.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-i0NF1x3cLckb8SvoaQD46CXg1/KXYdmA+8mE1qrpQzE=";
  };

  buildPhase = ''
    runHook preBuild

    yarn run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    yarn workspaces focus --production

    mkdir -p $out/bin $out/share/outline
    mv build server public node_modules $out/share/outline/
    find $out/share/outline/node_modules -name "*.map" -delete
    find $out/share/outline/node_modules -name "*.d.ts" -delete

    node_modules=$out/share/outline/node_modules
    build=$out/share/outline/build
    server=$out/share/outline/server

    makeWrapper ${nodejs-slim}/bin/node $out/bin/outline-server \
      --add-flags $build/server/index.js \
      --set NODE_ENV production \
      --set NODE_PATH $node_modules \
      --prefix PATH : ${lib.makeBinPath [ nodejs-slim ]} # required to run migrations

    runHook postInstall
  '';

  passthru = {
    tests = {
      basic-functionality = nixosTests.outline;
    };
    updateScript = ./update.sh;
    # alias for nix-update to be able to find and update this attribute
    inherit (finalAttrs) offlineCache;
  };

  meta = {
    description = "Fastest wiki and knowledge base for growing teams. Beautiful, feature rich, and markdown compatible";
    homepage = "https://www.getoutline.com/";
    changelog = "https://github.com/outline/outline/releases/v${finalAttrs.version}";
    license = lib.licenses.bsl11;
    maintainers = with lib.maintainers; [
      cab404
      e1mo
      xanderio
      yrd
    ];
    platforms = lib.platforms.linux;
  };
})
