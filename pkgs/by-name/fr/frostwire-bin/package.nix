{
  lib,
  stdenv,
  fetchurl,
  jre,
  makeWrapper,
  autoPatchelfHook,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "6.13.3";
  pname = "frostwire";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/frostwire/frostwire/releases/download/frostwire-desktop-${finalAttrs.version}-build-322/frostwire-${finalAttrs.version}.amd64.tar.gz";
    hash = "sha256-wRT8Oo+niOFBpEnq3pgjO9jpagZMgSE44V9RBYnGwig=";
  };

  nativeBuildInputs = [
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    zlib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/frostwire $out/share/applications

    cp -r * $out/share/frostwire/

    rm -rf $out/share/frostwire/jre

    mv $out/share/frostwire/frostwire.desktop $out/share/applications/
    substituteInPlace $out/share/applications/frostwire.desktop \
      --replace-fail "Exec=/usr/bin/frostwire %U" "Exec=$out/bin/frostwire %U" \
      --replace-fail "Icon=frostwire" "Icon=$out/share/frostwire/frostwire.png"

    substituteInPlace $out/share/frostwire/frostwire \
      --replace-fail "export JAVA_PROGRAM_DIR=/usr/lib/frostwire/jre/bin" "export JAVA_PROGRAM_DIR=${jre}/bin"

    patchShebangs $out/share/frostwire/frostwire

    makeWrapper $out/share/frostwire/frostwire $out/bin/frostwire \
      --prefix PATH : ${jre}/bin \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}:$out/share/frostwire" \
      --set JAVA_HOME "${jre}"

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.frostwire.com/";
    description = "BitTorrent Client and Cloud File Downloader";
    mainProgram = "frostwire";
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ gavin ];
    platforms = [ "x86_64-linux" ];
  };
})
