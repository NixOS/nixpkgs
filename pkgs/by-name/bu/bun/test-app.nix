{
  lib,
  stdenvNoCC,
  bun,
  unzip,
  autoPatchelfHook,
  makeBinaryWrapper,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "test-app";
  inherit (bun) version src;

  bunDeps = bun.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    hash = lib.fakeHash;
    nativeBuildInputs = [ unzip ];

    workspaces = [
      "bun-types"
    ];
  };

  strictDeps = true;
  nativeBuildInputs = [
    unzip
    bun.configHook
    makeBinaryWrapper
  ] ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [ autoPatchelfHook ];

  preBuild = ''
    bun --filter bun-types build
  '';

  # No one should be actually running this, so lets save some time
  buildType = "debug";
  doCheck = false;

  installPhase = ''
    runHook preInstall
    ls $out

    mkdir -p $out/bin
    cp -R ./* $out

    makeBinaryWrapper ${bun}/bin/bun $out/bin/test-app \
      --prefix PATH : ${lib.makeBinPath [ bun ]} \
      --add-flags "run --prefer-offline --no-install --cwd $out ./bun.js"

    runHook postInstall
  '';

  inherit (bun) meta;
})
