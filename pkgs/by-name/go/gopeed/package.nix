{
  lib,
  fetchFromGitHub,
  flutter,
  autoPatchelfHook,
  wrapGAppsHook3,
  buildGoModule,
  libayatana-appindicator,
}:
let
  pname = "gopeed";
  version = "1.6.1-unstable-2024-10-19";
  src = fetchFromGitHub {
    owner = "GopeedLab";
    repo = "gopeed";
    rev = "cd77665f02b1345e3446c09b9622f6f0c9b74975";
    hash = "sha256-m44lM7wf/ErOo5y7hBCMOJ3e8R+P6q79p4RV4wS0ASI=";
  };
  libgopeed = buildGoModule {
    inherit pname version src;
    vendorHash = "sha256-3C4emKsOdzAHiUFmWnvG0RHho3hKik7hO8e9ndXfzN0=";
    buildPhase = ''
      runHook preBuild
      mkdir -p $out/lib
      go build -tags nosqlite -ldflags="-w -s -X github.com/GopeedLab/gopeed/pkg/base.Version=v${version}" -buildmode=c-shared -o $out/lib/libgopeed.so github.com/GopeedLab/gopeed/bind/desktop
      runHook postBuild
    '';
  };
in
flutter.buildFlutterApplication {
  inherit pname version src;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes.permission_handler = "sha256-MRTmuH0MfhGaMEb9bRotimAPRlFyl3ovtJUJ2WK7+DA=";

  nativeBuildInputs = [
    wrapGAppsHook3
    autoPatchelfHook
  ];

  buildInputs = [ libayatana-appindicator ];

  sourceRoot = "./source/ui/flutter";

  postUnpack = ''
    substituteInPlace $sourceRoot/linux/my_application.cc \
      --replace-fail "gtk_widget_realize(GTK_WIDGET(window))" "gtk_widget_show(GTK_WIDGET(window))"
  '';

  preBuild = ''
    mkdir -p ./linux/bundle/lib/
    cp ${libgopeed}/lib/libgopeed.so ./linux/bundle/lib/libgopeed.so
  '';

  postInstall = ''
    mkdir -p $out/share/applications/ $out/share/icons/hicolor/512x512/apps/ $out/share/icons/hicolor/1024x1024/apps/
    cp ./linux/assets/com.gopeed.Gopeed.desktop $out/share/applications/
    cp ./assets/icon/icon_512.png $out/share/icons/hicolor/512x512/apps/com.gopeed.Gopeed.png
    cp ./assets/icon/icon_1024.png $out/share/icons/hicolor/1024x1024/apps/com.gopeed.Gopeed.png
  '';

  meta = {
    description = "Modern download manager that supports all platforms";
    homepage = "https://github.com/GopeedLab/gopeed";
    mainProgram = "gopeed";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ aucub ];
    platforms = lib.platforms.linux;
  };
}
