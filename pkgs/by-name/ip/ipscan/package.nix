{
  lib,
  stdenv,
  fetchurl,
  jdk,
  jre,
  swt,
  makeWrapper,
  xorg,
  dpkg,
  gtk3,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ipscan";
  version = "3.9.2";

  src = fetchurl {
    url = "https://github.com/angryip/ipscan/releases/download/${finalAttrs.version}/ipscan_${finalAttrs.version}_amd64.deb";
    hash = "sha256-5H6QCT7Z3EOJks/jLBluTCgJbqpRMW5iheds9nl4ktU=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  buildInputs = [ jdk ];

  installPhase = ''
    mkdir -p $out/share
    cp usr/lib/ipscan/ipscan-linux64-${finalAttrs.version}.jar $out/share/${finalAttrs.pname}-${finalAttrs.version}.jar

    makeWrapper ${jre}/bin/java $out/bin/ipscan \
      --prefix LD_LIBRARY_PATH : "$out/lib/:${
        lib.makeLibraryPath [
          swt
          xorg.libXtst
          gtk3
          glib
        ]
      }" \
      --add-flags "-Xmx256m -cp $out/share/${finalAttrs.pname}-${finalAttrs.version}.jar:${swt}/jars/swt.jar net.azib.ipscan.Main"

    mkdir -p $out/share/applications
    cp usr/share/applications/ipscan.desktop $out/share/applications/ipscan.desktop
    substituteInPlace $out/share/applications/ipscan.desktop --replace "/usr/bin" "$out/bin"

    mkdir -p $out/share/pixmaps
    cp usr/share/pixmaps/ipscan.png $out/share/pixmaps/ipscan.png
  '';

  meta = {
    description = "Angry IP Scanner - fast and friendly network scanner";
    mainProgram = "ipscan";
    homepage = "https://angryip.org";
    downloadPage = "https://github.com/angryip/ipscan/releases/tag/${finalAttrs.version}";
    changelog = "https://github.com/angryip/ipscan/blob/${finalAttrs.version}/CHANGELOG";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      kylesferrazza
      totoroot
    ];
  };
})
