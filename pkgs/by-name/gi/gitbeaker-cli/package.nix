{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  gnutar,
  makeBinaryWrapper,
  yarn-berry_4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gitbeaker-cli";
  version = "43.7.0";

  src = fetchFromGitHub {
    owner = "jdalrymple";
    repo = "gitbeaker";
    tag = finalAttrs.version;
    hash = "sha256-3g8VNOCyXxDg2xpLA66L57ASMhf0kWUp0a7a7FZouF8=";
  };

  nativeBuildInputs = [
    nodejs
    yarn-berry_4.yarnBerryConfigHook
    yarn-berry_4
    makeBinaryWrapper
    gnutar
  ];

  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry_4.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-RwQ/Xi/BKZv6+tpIIZU9U9PZJXq3baZVEv3UNKyQ18o=";
  };

  buildPhase = ''
    runHook preBuild

    yarn workspaces foreach -Rpt --from '@gitbeaker/*' run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/lib
    cp -r packages $out/lib/packages
    cp -r node_modules/ $out/lib/node_modules
    # Remove dev dependencies
    rm -rf $out/lib/node_modules/{.bin,tsup,typescript,@auto-it,@codecov,@swc,#types,@typescript-eslint,jest*,nx,prettier*,eslint*}

    runHook postInstall
  '';

  postFixup = ''
    chmod +x $out/lib/node_modules/@gitbeaker/cli/dist/index.mjs
    patchShebangs $out/lib/node_modules/@gitbeaker/cli/dist/index.mjs

    makeWrapper $out/lib/node_modules/@gitbeaker/cli/dist/index.mjs $out/bin/gb \
      --prefix PATH : ${lib.makeBinPath [ nodejs ]}

    ln -s $out/bin/gb $out/bin/gitbeaker
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    changelog = "https://github.com/jdalrymple/gitbeaker/releases/tag/${finalAttrs.version}";
    description = "CLI Wrapper for the @gitbeaker/rest SDK";
    homepage = "https://github.com/jdalrymple/gitbeaker";
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "gitbeaker";
  };
})
