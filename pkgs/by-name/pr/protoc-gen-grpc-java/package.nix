{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  autoPatchelfHook,
  nix-update-script,
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
        else if platform.isPower64 then
          "ppcle_64"
        else if platform.isS390x then
          "s390_64"
        else
          throw "Unsupported CPU \"${platform.parsed.cpu.name}\"";
    in
    "${os}-${arch}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "protoc-gen-grpc-java";
  version = "1.73.0";
  src = fetchurl {
    url = "https://repo1.maven.org/maven2/io/grpc/protoc-gen-grpc-java/${finalAttrs.version}/protoc-gen-grpc-java-${finalAttrs.version}-${hostArch}.exe";
    hash =
      {
        linux-aarch_64 = "sha256-sgdZoaSM7LgK4DbbKPJO3FdBA37YAX86meaKDLQiOmg=";
        linux-ppcle_64 = "sha256-k4nQGJNwtd8W4nJLyWPRhqjikczy7p7ffDIrWxkcUTA=";
        linux-s390_64 = "sha256-fcuNlJeUmduFzqt5WaefYk3lFVmdHeSFIEkbwT2I1O0=";
        linux-x86_32 = "sha256-KNvqGkeERd2UxzhjO/Fp6Uv7DGBt15rPGviRmH7pmno=";
        linux-x86_64 = "sha256-7LI115E3BOz3jnHavkQBbN0hsjKuSbnXNAjXFw/D14I=";
        osx-aarch_64 = "sha256-gAo2bcsivjDVFX5cUvzngoHgqTAPt+3Hiuynd17/KTo=";
        osx-x86_64 = "sha256-gAo2bcsivjDVFX5cUvzngoHgqTAPt+3Hiuynd17/KTo=";
        windows-x86_32 = "sha256-ERbksXFy4AFhZSFG9G4AMOi68EzEScBvDJFF9+rnPnU=";
        windows-x86_64 = "sha256-wZU6on7A84fPm8xwD8pBgSk8+fkB14LdvWZXEniz8LU=";
      }
      .${hostArch} or (throw "Unsuported host arch ${hostArch}");
  };
  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    makeWrapper
    autoPatchelfHook
  ];
  buildInputs = [ stdenv.cc.cc ];

  installPhase = ''
    runHook preInstall

    install -D $src $out/bin/protoc-gen-grpc-java

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "gRPC Java Codegen Plugin for Protobuf Compiler";
    longDescription = ''
      This generates the Java interfaces out of the service definition from a `.proto` file.
      It works with the Protobuf Compiler (`protoc`).
    '';
    changelog = "https://github.com/grpc/grpc-java/releases/tag/v${finalAttrs.version}";
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.progrm_jarvis ];
    homepage = "https://checkstyle.org/";
    platforms = with lib.platforms; linux ++ darwin ++ windows;
  };
})
