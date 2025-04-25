{
  lib,
  fetchFromGitHub,
  makeWrapper,
  maven,
  jre,
  makeDesktopItem,
  copyDesktopItems,
  nix-update-script,
}:
maven.buildMavenPackage rec {
  pname = "muon-ssh";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "devlinx9";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Ys82bXZFuHNOhpIYj5Ip7tNLZ8+mStbs5l8y2rB2btI=";
  };

  patches = [
    # removes builders for .exe, .deb, .dmg as they are not needed on nix and create issues while building as they use dynamically linked executables
    ./no-builders.patch

    # replaces the out-of-date repository with the correct one (see https://github.com/devlinx9/muon-ssh/issues/131#issuecomment-2881808405)
    ./jediterm.patch
  ];

  mvnHash = "sha256-df7Nj5SboVXKmRTsFELK2Pdb1NM8rySYLcSU/Ex8LFw=";

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = meta.mainProgram;
      icon = pname;
      desktopName = "Muon SSH";
      genericName = meta.description;
      categories = [
        "Network"
        "RemoteAccess"
      ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/muon-ssh
    install -Dm644 muon-app/target/muonssh_${version}.jar $out/share/muon-ssh/muon-ssh.jar

    makeWrapper ${jre}/bin/java $out/bin/muon-ssh \
      --add-flags "-jar $out/share/muon-ssh/muon-ssh.jar"

    install -Dm644 "muon-app/src/main/resources/muon.png" "$out/usr/share/icons/hicolor/256x256/apps/muon-ssh.png"

    runHook postInstall
  '';

  meta = {
    description = "Graphical SFTP client and terminal emulator (SSH) with helpful utilities";
    homepage = "https://github.com/devlinx9/muon-ssh";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ quio ];
    mainProgram = "muon-ssh";
    platforms = lib.platforms.linux;
  };
}
