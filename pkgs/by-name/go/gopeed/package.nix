{
  lib,
  fetchFromGitHub,
  flutter316,
  stdenv,
  autoPatchelfHook,
  wrapGAppsHook3,
  buildGoModule,
  libayatana-appindicator,
}:
let
  pname = "gopeed";
  version = "1.6.0";
  src = fetchFromGitHub {
    owner = "GopeedLab";
    repo = "gopeed";
    rev = "v${version}";
    hash = "sha256-1ryP9qvTv6wG5jtTZynoDiXc06xmLA7akdrLDszFgzI=";
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
flutter316.buildFlutterApplication {

  inherit pname version src;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeBuildInputs = [
    wrapGAppsHook3
    autoPatchelfHook
  ];

  buildInputs = [ libayatana-appindicator ];

  sourceRoot = "./source/ui/flutter";

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
    platforms = with lib.platforms; linux ++ darwin;
    broken = !(stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64);
  };
}
