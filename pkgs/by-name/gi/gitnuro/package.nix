{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  jdk25,
  libGL,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gitnuro";
  version = "2.0.0";

  src = fetchurl (
    if stdenv.hostPlatform.system == "x86_64-linux" then
      {
        url = "https://github.com/JetpackDuba/Gitnuro/releases/download/${finalAttrs.version}/Gitnuro-linux-x86_64-2.0-${finalAttrs.version}.jar";
        hash = "sha256-7AaIHJT++xW9YSDoNUmx4YsOS7uqxTAQs4QJtLfubvg=";
      }
    else if stdenv.hostPlatform.system == "aarch64-linux" then
      {
        url = "https://github.com/JetpackDuba/Gitnuro/releases/download/${finalAttrs.version}/Gitnuro-linux-arm_aarch64-2.0-${finalAttrs.version}.jar";
        hash = "sha256-BBTkXcHGBHRRDFyrVP8yH+5vhBQCU9kkv0jb3i19zSE=";
      }
    else
      throw "Unsupported architecture: ${stdenv.hostPlatform.system}"
  );

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/JetpackDuba/Gitnuro/4cfc45069c176f807d9bfb1a7cba410257078d3c/icons/logo.svg";
    hash = "sha256-QGJcWTSJesIpDArOWiS3Kn1iznzeMFzvqS+CuNXh3as=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  installPhase = ''
    runHook preInstall

    makeWrapper ${jdk25}/bin/java $out/bin/gitnuro \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libGL ]}" \
      --add-flags "-jar $src"

    install -Dm444 $icon $out/share/icons/hicolor/scalable/apps/com.jetpackduba.Gitnuro.svg

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Gitnuro";
      exec = "gitnuro";
      icon = "com.jetpackduba.Gitnuro";
      desktopName = "Gitnuro";
      categories = [ "Development" ];
      comment = finalAttrs.meta.description;
    })
  ];

  meta = {
    description = "FOSS Git multiplatform client based on Compose and JGit";
    homepage = "https://gitnuro.com/";
    downloadPage = "https://github.com/JetpackDuba/Gitnuro";
    license = lib.licenses.gpl3Plus;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "gitnuro";
  };
})
