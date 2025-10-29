{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  autoPatchelfHook,
}:
let
  hostArch =
    let
      platform = stdenv.hostPlatform;
      os =
        if platform.isLinux then
          "linux"
        else if platform.isDarwin then
          "osx"
        else if platform.isWindows then
          "windows"
        else
          throw "Unsupoprted OS \"${platform.parsed.kernel.name}\"";
      arch =
        if platform.isx86_32 then
          "x86_32"
        else if platform.isx86_64 then
          "x86_64"
        else if platform.isAarch64 then
          "aarch_64"
        else if platform.isPower64 && platform.isLittleEndian then
          "ppcle_64"
        else if platform.isS390x then
          "s390_64"
        else
          throw "Unsupported CPU \"${platform.parsed.cpu.name}\"";
    in
    "${os}-${arch}";
  data = import ./data.nix;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "protoc-gen-grpc-java";
  inherit (data) version;
  src = fetchurl {
    url = "https://repo1.maven.org/maven2/io/grpc/protoc-gen-grpc-java/${finalAttrs.version}/protoc-gen-grpc-java-${finalAttrs.version}-${hostArch}.exe";
    hash = data.hashes.${hostArch} or (throw "Unsuported host arch ${hostArch}");
  };
  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = (lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ]) ++ [
    makeWrapper
  ];
  buildInputs = [ stdenv.cc.cc ];

  installPhase = ''
    runHook preInstall

    install -D $src $out/bin/protoc-gen-grpc-java

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "gRPC Java Codegen Plugin for Protobuf Compiler";
    longDescription = ''
      This generates the Java interfaces out of the service definition from a `.proto` file.
      It works with the Protobuf Compiler (`protoc`).
    '';
    changelog = "https://github.com/grpc/grpc-java/releases/tag/v${finalAttrs.version}";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.progrm_jarvis ];
    homepage = "https://grpc.io/docs/languages/java/generated-code/";
    platforms = [
      # Linux
      "x86_64-linux"
      "i686-linux"
      "aarch64-linux"
      "powerpc64le-linux"
      "s390x-linux"
      # Darwin
      "x86_64-darwin"
      "aarch64-darwin"
      # Windows
      "x86_64-windows"
      "i686-windows"
    ];
  };
})
