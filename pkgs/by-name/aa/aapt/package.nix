{
  lib,
  stdenvNoCC,
  fetchzip,
  autoPatchelfHook,
  libcxx,
}:

stdenvNoCC.mkDerivation rec {
  pname = "aapt";
  version = "8.13.2-14304508";

  src =
    let
      urlAndHash =
        if stdenvNoCC.hostPlatform.isLinux then
          {
            url = "https://dl.google.com/android/maven2/com/android/tools/build/aapt2/${version}/aapt2-${version}-linux.jar";
            hash = "sha256-eiNY58ueDpcyKvAteRuKFVr3r22kOhwSADkaH3CRwKw=";
          }
        else if stdenvNoCC.hostPlatform.isDarwin then
          {
            url = "https://dl.google.com/android/maven2/com/android/tools/build/aapt2/${version}/aapt2-${version}-osx.jar";
            hash = "sha256-RI/S2oXMSvipALRfeRTsiXUh130/b8iP+EO0yltd7x0=";
          }
        else
          throw "Unsupport platform: ${stdenvNoCC.system}";
    in
    fetchzip (
      urlAndHash
      // {
        extension = "zip";
        stripRoot = false;
      }
    );

  nativeBuildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [ libcxx ];

  installPhase = ''
    runHook preInstall

    install -D aapt2 $out/bin/aapt2

    runHook postInstall
  '';

  meta = {
    description = "Build tool that compiles and packages Android app's resources";
    mainProgram = "aapt2";
    homepage = "https://developer.android.com/tools/aapt2";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ linsui ];
    teams = [ lib.teams.android ];
    platforms = lib.platforms.darwin ++ [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
