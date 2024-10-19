{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  testers,
  mirrord-bin,
}:

let
  manifest = lib.importJSON ./manifest.json;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mirrord-bin";
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
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    install -D $src $out/bin/mirrord
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = mirrord-bin;
    };
    updateScript = ./update.py;
  };

  meta = with lib; {
    description = "Run local processes in the context of Kubernetes environment";
    homepage = "https://mirrord.dev/";
    license = licenses.mit;
    platforms = attrNames manifest.assets;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "mirrord";
  };
})
