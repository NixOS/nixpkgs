{
  stdenv,
  lib,
  fetchFromGitHub,
  substitute,
  makeWrapper,
  nodejs,
  nixosTests,
  yarn-berry_4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "outline";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "outline";
    repo = "outline";
    rev = "v${finalAttrs.version}";
    hash = "sha256-msFMfjNkpXaJisbTpJMQowyD0KZ5zfvSgTutEeLp9Vk=";

    # Remove after upstream updates to Yarn 4.15
    # https://github.com/outline/outline/blob/main/package.json#L393
    postFetch = ''
      cd $out
      patch -p1 < ${
        (substitute {
          src = ./yarn-fix.patch;
          substitutions = [
            "--replace-fail"
            "YARN_LOCKFILE_VERSION_PLACEHOLDER"
            yarn-berry_4.lockfileVersion
          ];
        })
      }
    '';
  };

  missingHashes = ./missing-hashes.json;

  nativeBuildInputs = [
    makeWrapper
    yarn-berry_4.yarnBerryConfigHook
    yarn-berry_4
  ];

  offlineCache = yarn-berry_4.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-bEsnu4NL/Dgv6yPXXvV/4uMvQ7Sc9eDfeAD2fhFCB98=";
  };

  buildPhase = ''
    runHook preBuild

    yarn run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/outline
    mv build server public node_modules $out/share/outline/

    node_modules=$out/share/outline/node_modules
    build=$out/share/outline/build
    server=$out/share/outline/server

    makeWrapper ${nodejs}/bin/node $out/bin/outline-server \
      --add-flags $build/server/index.js \
      --set NODE_ENV production \
      --set NODE_PATH $node_modules \
      --prefix PATH : ${lib.makeBinPath [ nodejs ]} # required to run migrations

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
