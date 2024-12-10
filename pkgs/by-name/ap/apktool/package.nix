{ lib
, stdenv
, fetchurl
, makeWrapper
, jdk_headless
, aapt
}:

stdenv.mkDerivation rec {
  pname = "apktool";
  version = "2.10.0";

  src = fetchurl {
    urls = [
      "https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_${version}.jar"
      "https://github.com/iBotPeaches/Apktool/releases/download/v${version}/apktool_${version}.jar"
    ];
    hash = "sha256-wDUKu6tTFCSN/i7gyQfe9O3RT2+u8fXTctPUq9KPBDE=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  sourceRoot = ".";

  installPhase =
    ''
      install -D ${src} "$out/libexec/apktool/apktool.jar"
      mkdir -p "$out/bin"
      makeWrapper "${jdk_headless}/bin/java" "$out/bin/apktool" \
          --add-flags "-jar $out/libexec/apktool/apktool.jar" \
          --prefix PATH : ${lib.getBin aapt}
    '';

  meta = with lib; {
    description = "Tool for reverse engineering Android apk files";
    mainProgram = "apktool";
    homepage = "https://ibotpeaches.github.io/Apktool/";
    changelog = "https://github.com/iBotPeaches/Apktool/releases/tag/v${version}";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = with platforms; unix;
  };
}
