{
  autoPatchelfHook,
  fetchurl,
  lib,
  stdenv,
}:

let
  inherit (lib) licenses platforms;
  inherit (lib.maintainers) patwid;
  inherit (lib.sourceTypes) binaryNativeCode;
  inherit (stdenv.hostPlatform) system;

  version = "1.70.0";
  mainProgram = "protoc-gen-grpc-java";
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
    license = licenses.asl20;
    platforms = platforms.linux;
    sourceProvenance = [ binaryNativeCode ];
    inherit mainProgram;
    maintainers = [ patwid ];
  };
}
