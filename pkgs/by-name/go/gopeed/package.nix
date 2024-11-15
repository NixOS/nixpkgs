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
  version = "1.6.2-unstable-2024-11-15";
  src = fetchFromGitHub {
    owner = "GopeedLab";
    repo = "gopeed";
    rev = "4dd922457bcb0894a92ddbcdba4424864669c369";
    hash = "sha256-LCJElpFHlrORs94eRsWGdwMZm1QThU5fJzsS45HmAx8=";
  };
  libgopeed = buildGoModule {
    inherit pname version src;

    vendorHash = "sha256-AYl1g0GxWzhPQq96MrjAykl3eTqsPtMhrcxhEKJkc4U=";

    buildPhase = ''
      runHook preBuild

      mkdir -p $out/lib
      go build -tags nosqlite -ldflags="-w -s -X github.com/GopeedLab/gopeed/pkg/base.Version=v${version}" -buildmode=c-shared -o $out/lib/libgopeed.so github.com/GopeedLab/gopeed/bind/desktop

      runHook postBuild
    '';

    meta = {
      description = "Modern download manager that supports all platforms";
      homepage = "https://github.com/GopeedLab/gopeed";
      license = with lib.licenses; [ gpl3Plus ];
      maintainers = with lib.maintainers; [ aucub ];
      platforms = lib.platforms.linux;
    };
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

  sourceRoot = "${src.name}/ui/flutter";

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
