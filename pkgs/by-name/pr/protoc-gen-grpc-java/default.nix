{
  stdenv,
  lib,
  fetchurl,
  protobuf,
  autoPatchelfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "protoc-gen-grpc-java";
  version = "1.70.0";

  src =
    let
      system =
        {
          "x86_64-linux" = "linux-x86_64";
          "aarch64-linux" = "linux-aarch_64";
          "x86_64-darwin" = "osx-x86_64";
          "aarch64-darwin" = "osx-aarch_64";
        }
        .${stdenv.hostPlatform.system};
    in
    with finalAttrs;
    fetchurl {
      url = "https://repo1.maven.org/maven2/io/grpc/${pname}/${version}/${pname}-${version}-${system}.exe";
      hash = "sha256-NjP0iznsJAtpIFxjCpt9o+Jt/knxI3MGIAhAStGCPLw=";
    };

  dontUnpack = true;

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    protobuf
  ];

  installPhase = ''
    runHook preInstall
    install -m755 -D $src $out/bin/protoc-gen-grpc-java
    runHook postInstall
  '';

  meta = with lib; {
    description = "Protobuf plugin for generating Java code";
    homepage = "https://github.com/grpc/grpc-java";
    license = licenses.asl20;
    maintainers = with maintainers; [ patwid ];
  };
})
