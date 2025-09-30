{
  lib,
  stdenv,
  fetchurl,
  makeDesktopItem,
  jdk8,
  copyDesktopItems,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "jxplorer";
  version = "3.3.1.2";

  src = fetchurl {
    url = "https://github.com/pegacat/jxplorer/releases/download/v${version}/jxplorer-${version}-project.tar.bz2";
    hash = "sha256-/lWkavH51OqNFSLpgT+4WcQcfW3WvnnOkB03jB7bE/s=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "JXplorer";
      exec = "jxplorer";
      comment = "A Java Ldap Browser";
      desktopName = "JXplorer";
      genericName = "Java Ldap Browser";
      icon = "jxplorer";
    })
  ];

  installPhase = ''
    runHook preInstall
    install -d "$out/opt/jxplorer" "$out/bin" "$out/share/pixmaps"
    cp -r ./. "$out/opt/jxplorer"
    install -Dm644 images/JX128.png "$out/share/pixmaps/jxplorer.png"
    runHook postInstall
  '';

  postFixup = ''
    chmod +x $out/opt/jxplorer/jxplorer.sh
    makeWrapper $out/opt/jxplorer/jxplorer.sh $out/bin/jxplorer \
      --chdir $out/opt/jxplorer \
      --set JAVA_HOME ${jdk8}
  '';

  meta = with lib; {
    description = "Java Ldap Browser";
    homepage = "https://sourceforge.net/projects/jxplorer/";
    license = lib.licenses.asl11;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
    mainProgram = "jxplorer";
  };
}
