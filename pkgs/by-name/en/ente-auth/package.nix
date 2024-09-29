{
  lib,
  flutter324,
  fetchFromGitHub,
  webkitgtk,
  sqlite,
  libayatana-appindicator,
  makeDesktopItem,
  copyDesktopItems,
  imagemagick,
  makeWrapper,
  xdg-user-dirs,
}:
let
  # fetch simple-icons directly to avoid cloning with submodules,
  # which would also clone a whole copy of flutter
  simple-icons = fetchFromGitHub (lib.importJSON ./simple-icons.json);
in
flutter324.buildFlutterApplication rec {
  pname = "ente-auth";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "ente-io";
    repo = "ente";
    sparseCheckout = [ "auth" ];
    rev = "auth-v${version}";
    hash = "sha256-me+fT79vwqBBNsRWWo58GdzBf58LNB4Mk+pmCLvn/ik=";
  };

  sourceRoot = "${src.name}/auth";

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  patchPhase = ''
    rmdir assets/simple-icons
    ln -s ${simple-icons} assets/simple-icons
  '';

  gitHashes = {
    desktop_webview_window = "sha256-jdNMpzFBgw53asWlGzWUS+hoPdzcL6kcJt2KzjxXf2E=";
    ente_crypto_dart = "sha256-XBzQ268E0cYljJH6gDS5O0Pmie/GwuhMDlQPfopSqJM=";
    flutter_local_authentication = "sha256-r50jr+81ho+7q2PWHLf4VnvNJmhiARZ3s4HUpThCgc0=";
    flutter_secure_storage_linux = "sha256-x45jrJ7pvVyhZlpqRSy3CbwT4Lna6yi/b2IyAilWckg=";
    sqflite = "sha256-TdvCtEO7KL1R2oOSwGWllmS5kGCIU5CkvvUqUJf3tUc=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    imagemagick
    makeWrapper
  ];

  buildInputs = [
    webkitgtk
    sqlite
    libayatana-appindicator
  ];

  # Based on https://github.com/ente-io/ente/blob/main/auth/linux/packaging/rpm/make_config.yaml
  # and https://github.com/ente-io/ente/blob/main/auth/linux/packaging/ente_auth.appdata.xml
  desktopItems = makeDesktopItem {
    name = "ente_auth";
    exec = "ente_auth";
    icon = "ente-auth";
    desktopName = "Ente Auth";
    genericName = "Ente Authentication";
    comment = "Open source 2FA authenticator, with end-to-end encrypted backups";
    categories = [ "Utility" ];
    keywords = [
      "Authentication"
      "2FA"
    ];
    mimeTypes = [ "x-scheme-handler/enteauth" ];
    startupNotify = false;
  };

  postInstall = ''
    FAV=$out/app/data/flutter_assets/assets/icons/auth-icon.png
    ICO=$out/share/icons

    install -D $FAV $ICO/ente-auth.png
    for size in 24 32 42 64 128 256 512; do
      D=$ICO/hicolor/''${size}x''${size}/apps
      mkdir -p $D
      magick $FAV -resize ''${size}x''${size} $D/ente-auth.png
    done

    install -Dm444 linux/packaging/ente_auth.appdata.xml -t $out/share/metainfo

    wrapProgram $out/bin/ente_auth \
      --prefix PATH : ${lib.makeBinPath [ xdg-user-dirs ]}
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "End-to-end encrypted, cross platform and free app for storing your 2FA codes with cloud backups";
    longDescription = ''
      Ente's 2FA app. An end-to-end encrypted, cross platform and free app for storing your 2FA codes with cloud backups. Works offline. You can even use it without signing up for an account if you don't want the cloud backups or multi-device sync.
    '';
    homepage = "https://ente.io/auth/";
    changelog = "https://github.com/ente-io/ente/releases/tag/auth-v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      niklaskorz
      schnow265
      zi3m5f
      gepbird
    ];
    mainProgram = "ente_auth";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
