{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
}:

let
  inherit (stdenv.hostPlatform) system;
  inherit (lib.licenses) asl20;
  inherit (lib.sourceTypes) binaryNativeCode;
  inherit (lib.maintainers) patwid;

  version = "1.70.0";
  mainProgram = "protoc-gen-grpc";
in
stdenv.mkDerivation {
  pname = "protoc-gen-grpc-java-bin";
  inherit version;

  src = fetchurl (import ./urls.nix).${system};

  dontUnpack = true;

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall
    install -m755 -D $src $out/bin/${mainProgram}
    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Protobuf plugin for generating Java code";
    homepage = "https://github.com/grpc/grpc-java/blob/master/compiler";
    license = asl20;
    sourceProvenance = [ binaryNativeCode ];
    inherit mainProgram;
    maintainers = [ patwid ];
  };
}
