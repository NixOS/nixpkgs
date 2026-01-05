{
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  lib,
  flutter332,
  quickemu,
}:
flutter332.buildFlutterApplication rec {
  pname = "quickgui";
  version = "1.2.10";
  src = fetchFromGitHub {
    owner = "quickemu-project";
    repo = "quickgui";
    rev = version;
    hash = "sha256-M2Qy66RqsjXg7ZpHwaXCN8qXRIsisnIyaENx3KqmUfQ=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    window_size = "sha256-XelNtp7tpZ91QCEcvewVphNUtgQX7xrp5QP0oFo6DgM=";
  };

  extraWrapProgramArgs = "--prefix PATH : ${
    lib.makeBinPath [
      quickemu
    ]
  }";

  nativeBuildInputs = [ copyDesktopItems ];

  postFixup = ''
    for n in 16 32 48 64 128 256 512; do
      size=$n"x"$n
      mkdir -p $out/share/icons/hicolor/$size/apps/
      cp -av assets/resources/quickgui_$n.png $out/share/icons/hicolor/$size/apps/quickgui.png
    done
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "quickgui";
      exec = "quickgui";
      icon = "quickgui";
      desktopName = "Quickgui";
      comment = "An elegant virtual machine manager for the desktop";
      categories = [
        "Development"
        "System"
      ];
    })
  ];

  meta = with lib; {
    description = "Elegant virtual machine manager for the desktop";
    homepage = "https://github.com/quickemu-project/quickgui";
    changelog = "https://github.com/quickemu-project/quickgui/releases/";
    license = licenses.mit;
    maintainers = with maintainers; [
      flexiondotorg
      heyimnova
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "quickgui";
  };
}
