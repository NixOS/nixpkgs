{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  temurin-jre-bin-11,
  bash,
  suitesparse,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "photonvision";
  version = "2024.3.1";

  src =
    {
      "x86_64-linux" = fetchurl {
        url = "https://github.com/PhotonVision/photonvision/releases/download/v${version}/photonvision-v${version}-linuxx64.jar";
        hash = "sha256-t9drkGFA3IurZqWAkzEaONVJkp5JHMEFBBW50r+SD68=";
      };
      "aarch64-linux" = fetchurl {
        url = "https://github.com/PhotonVision/photonvision/releases/download/v${version}/photonvision-v${version}-linuxarm64.jar";
        hash = "sha256-ninCVxse0x6lBA2NL3kwMeuHAeNzSa9rdP2dnmMNFgc=";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -D $src $out/lib/photonvision.jar

    makeWrapper ${temurin-jre-bin-11}/bin/java $out/bin/photonvision \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          stdenv.cc.cc.lib
          suitesparse
        ]
      } \
      --prefix PATH : ${
        lib.makeBinPath [
          temurin-jre-bin-11
          bash.out
        ]
      } \
      --add-flags "-jar $out/lib/photonvision.jar"

    runHook postInstall
  '';

  passthru.tests = {
    starts-web-server = nixosTests.photonvision;
  };

  meta = with lib; {
    description = "Free, fast, and easy-to-use computer vision solution for the FIRST Robotics Competition";
    homepage = "https://photonvision.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ max-niederman ];
    mainProgram = "photonvision";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
