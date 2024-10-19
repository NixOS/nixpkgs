{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  testers,
  starpls-bin,
}:

let
  manifest = lib.importJSON ./manifest.json;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "starpls-bin";
  version = manifest.version;

  src =
    let
      system = stdenv.hostPlatform.system;
    in
    fetchurl (manifest.assets.${system} or (throw "Unsupported system: ${system}"));

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isElf [
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isElf [
    (lib.getLib stdenv.cc.cc)
  ];

  installPhase = ''
    install -D $src $out/bin/starpls
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = starpls-bin;
      command = "starpls version";
      version = "v${finalAttrs.version}";
    };
    updateScript = ./update.py;
  };

  meta = {
    description = "Language server for Starlark";
    homepage = "https://github.com/withered-magic/starpls";
    license = lib.licenses.asl20;
    platforms = builtins.attrNames manifest.assets;
    maintainers = with lib.maintainers; [ aaronjheng ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "starpls";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
