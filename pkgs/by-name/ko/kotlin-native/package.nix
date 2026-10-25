{
  lib,
  stdenv,
  fetchurl,
  jre,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "kotlin-native";
  version = "2.4.21";

  src =
    let
      getArch =
        {
          "aarch64-darwin" = "macos-aarch64";
          "x86_64-linux" = "linux-x86_64";
        }
        .${stdenv.system} or (throw "${pname}-${version}: ${stdenv.system} is unsupported.");

      getUrl =
        version: arch:
        "https://github.com/JetBrains/kotlin/releases/download/v${version}/kotlin-native-prebuilt-${arch}-${version}.tar.gz";

      getHash =
        arch:
        {
          "macos-aarch64" = "sha256-v07bUm2R4X0IYhAvaSUFJdeI55AR+GwsZDYnSa3yYK4=";
          "macos-x86_64" = "sha256-dBeZ8WOtJA9/5U+uUzRJDFqKj8qbnp05SV20l7Txdjw=";
          "linux-x86_64" = "sha256-STXYyNqQotKo/1HafSwmTA1gJuHTWo8WniGNkgmWVng=";
        }
        .${arch};
    in
    fetchurl {
      url = getUrl version getArch;
      sha256 = getHash getArch;
    };

  nativeBuildInputs = [
    jre
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv * $out

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/run_konan --prefix PATH ":" ${lib.makeBinPath [ jre ]}
  '';

  meta = {
    homepage = "https://kotlinlang.org/";
    description = "Modern programming language that makes developers happier";
    longDescription = ''
      Kotlin/Native is a technology for compiling Kotlin code to native
      binaries, which can run without a virtual machine. It is an LLVM based
      backend for the Kotlin compiler and native implementation of the Kotlin
      standard library.
    '';
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fabianhjr ];
    platforms = [ "x86_64-linux" ] ++ lib.platforms.darwin;
  };
}
