{
  lib,
  stdenv,
  fetchurl,
  testers,
  mirrord,
  autoPatchelfHook,
}:

let
  manifest = lib.importJSON ./manifest.json;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mirrord";
  version = manifest.version;

  src = fetchurl (manifest.assets.${stdenv.hostPlatform.system});

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isElf [
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isElf [
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    install -D $src $out/bin/mirrord
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = mirrord;
    };
    updateScript = ./update.py;
  };

  meta = {
    description = "Run local processes in the context of Kubernetes environment";
    homepage = "https://mirrord.dev/";
    license = lib.licenses.mit;
    platforms = builtins.attrNames manifest.assets;
    maintainers = with lib.maintainers; [ aaronjheng ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "mirrord";
  };
})
