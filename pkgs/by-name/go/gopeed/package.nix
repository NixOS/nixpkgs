{
  lib,
  fetchFromGitHub,
  flutter324,
  autoPatchelfHook,
  buildGoModule,
  libayatana-appindicator,
}:

let
  version = "1.6.8";

  src = fetchFromGitHub {
    owner = "GopeedLab";
    repo = "gopeed";
    tag = "v${version}";
    hash = "sha256-Z6t652m420FcCK4V9sG9I+Dzc2OTyXwWunBhVSreyac=";
  };

  metaCommon = {
    description = "Modern download manager that supports all platforms";
    homepage = "https://github.com/GopeedLab/gopeed";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };

  libgopeed = buildGoModule {
    inherit version src;
    pname = "libgopeed";

    vendorHash = "sha256-rJriTQF4tf7sZXcEDS6yZXk3xUI8Cav8OC7o4egpfIw=";

    buildPhase = ''
      runHook preBuild

      mkdir -p $out/lib
      go build -tags nosqlite -ldflags="-w -s -X github.com/GopeedLab/gopeed/pkg/base.Version=v${version}" -buildmode=c-shared -o $out/lib/libgopeed.so github.com/GopeedLab/gopeed/bind/desktop

      runHook postBuild
    '';

    meta = metaCommon;
  };
in
flutter324.buildFlutterApplication {
  inherit version src libgopeed;
  pname = "gopeed";

  sourceRoot = "${src.name}/ui/flutter";

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes.permission_handler_windows = "sha256-MRTmuH0MfhGaMEb9bRotimAPRlFyl3ovtJUJ2WK7+DA=";

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [ libayatana-appindicator ];

  preBuild = ''
    mkdir -p linux/bundle/lib
    cp ${libgopeed}/lib/libgopeed.so linux/bundle/lib/libgopeed.so
  '';

  postInstall = ''
    install -Dm644 linux/assets/com.gopeed.Gopeed.desktop $out/share/applications/gopeed.desktop
    install -Dm644 assets/icon/icon_512.png $out/share/icons/hicolor/512x512/apps/com.gopeed.Gopeed.png
    install -Dm644 assets/icon/icon_1024.png $out/share/icons/hicolor/1024x1024/apps/com.gopeed.Gopeed.png
  '';

  passthru.updateScript = ./update.sh;

  meta = metaCommon // {
    mainProgram = "gopeed";
  };
}
