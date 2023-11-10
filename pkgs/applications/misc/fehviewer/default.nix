{ lib
, flutter
, fetchFromGitHub
, makeDesktopItem
, pkg-config
}:

flutter.buildFlutterApplication rec {
  pname = "fehviwer";
  version = "testing_linux";

  #pubspecLockFile = ./pubspec.lock;
  depsListFile = ./deps.json;
  vendorHash = "sha256-QqR1isHtQqGDhxkzuy5hm7Vem9iI1qBfK5GZLt/h03U=";

  src = fetchFromGitHub {
    owner = "Rucadi";
    repo = "FEhViewer";
    rev = "master";
    hash = "sha256-Sx7JkzgH/8NRpG5h/5aeqsZa4Jqd3M7vy4rlAQ+xHVA=";
  };

  prePatch = ''
    mv lib/config/config.dart.sample lib/config/config.dart 
  '';

  postInstall = ''
    rm -rf $out/bin/*
    makeWrapper $out/app/fehviewer $out/bin/fehviewer  \
            --prefix LD_LIBRARY_PATH : $out/app/lib
  '';


desktopItem = makeDesktopItem {
    name = "FEhViewer";
    exec = "@out@/bin/fehviewer";
    #icon = "fehviewer";
    desktopName = "FEhViewer";
    genericName = "View E-Hentai and ExHentai libraries!";
    categories = [ "Adult" "Viewer" "Art" ];
  };

  meta = with lib; {
    description = "View E-Hentai and ExHentai libraries!";
    homepage = "https://github.com/3003h/FEhViewer";
    license =  "Apache 2.0";
    maintainers = with maintainers; [  ];
    platforms = platforms.linux;
  };
}
