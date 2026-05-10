{
  lib,
  fetchFromGitHub,
  flutter338,
  autoPatchelfHook,
  buildGoModule,
  keybinder3,
  libayatana-appindicator,
}:

let
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "GopeedLab";
    repo = "gopeed";
    tag = "v${version}";
    hash = "sha256-kLWhAQfzqZ9/THYeU/W4YOJYfMnqoTbyobC2P9YYddI=";
  };

  metaCommon = {
    description = "Modern download manager";
    homepage = "https://github.com/GopeedLab/gopeed";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };

  libgopeed = buildGoModule {
    inherit version src;
    pname = "libgopeed";

    vendorHash = "sha256-XTVFqKn0JeOC/QFns0GhIYqu1FB+eFg6bgIi4G7Lw1o=";

    buildPhase = ''
      runHook preBuild

      mkdir -p $out/lib $out/bin
      go build -tags nosqlite -ldflags="-w -s -X github.com/GopeedLab/gopeed/pkg/base.Version=v${version}" -buildmode=c-shared -o $out/lib/libgopeed.so github.com/GopeedLab/gopeed/bind/desktop
      go build -ldflags="-w -s" -o $out/bin/host github.com/GopeedLab/gopeed/cmd/host

      runHook postBuild
    '';

    meta = metaCommon;
  };
in
flutter338.buildFlutterApplication {
  inherit version src;
  pname = "gopeed";

  sourceRoot = "${src.name}/ui/flutter";

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = lib.importJSON ./git-hashes.json;

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    keybinder3
    libayatana-appindicator
  ];

  preBuild = ''
    mkdir -p linux/bundle/lib
    cp ${libgopeed}/lib/libgopeed.so linux/bundle/lib/libgopeed.so
    cp ${libgopeed}/bin/host assets/exec/host
  '';

  postInstall = ''
    install -Dm644 linux/assets/com.gopeed.Gopeed.desktop $out/share/applications/gopeed.desktop
    install -Dm644 assets/icon/icon_512.png $out/share/icons/hicolor/512x512/apps/com.gopeed.Gopeed.png
    install -Dm644 assets/icon/icon_1024.png $out/share/icons/hicolor/1024x1024/apps/com.gopeed.Gopeed.png
  '';

  preFixup = ''
    patchelf --add-needed libgopeed.so \
      --add-rpath $out/app/gopeed/lib $out/app/gopeed/gopeed
  '';

  passthru = {
    inherit libgopeed;
    updateScript = ./update.sh;
  };

  meta = metaCommon // {
    mainProgram = "gopeed";
  };
}
