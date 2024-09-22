{
  lib,
  fetchFromGitHub,
  flutter324,
  fuse,
  gtk3,
  libappindicator-gtk3,
  libffi,
  libsecret,
  libsodium,
  libtiff,
  pkg-config,
  sqlite,
  webkitgtk,
}:
let
  pname = "ente-auth";
  version = "3.1.3";

in
flutter324.buildFlutterApplication {
  inherit pname version;

  src =
    fetchFromGitHub {
      owner = "ente-io";
      repo = "ente";
      sparseCheckout = [ "auth" ];
      rev = "refs/tags/auth-v${version}";
      fetchSubmodules = true;
      hash = "sha256-v6pZQM/kznOv/vmgEYxEL8BwgQDOjVhHlHW2MWrxxN8=";
    }
    + "/auth";

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    desktop_webview_window = "sha256-jdNMpzFBgw53asWlGzWUS+hoPdzcL6kcJt2KzjxXf2E=";
    ente_crypto_dart = "sha256-XBzQ268E0cYljJH6gDS5O0Pmie/GwuhMDlQPfopSqJM=";
    flutter_local_authentication = "sha256-r50jr+81ho+7q2PWHLf4VnvNJmhiARZ3s4HUpThCgc0=";
    flutter_secure_storage_linux = "sha256-x45jrJ7pvVyhZlpqRSy3CbwT4Lna6yi/b2IyAilWckg=";
    sqflite = "sha256-TdvCtEO7KL1R2oOSwGWllmS5kGCIU5CkvvUqUJf3tUc=";
  };

  nativeBuildInputs = [
    fuse
    gtk3
    libappindicator-gtk3
    libffi
    libsecret
    libsodium
    libtiff
    pkg-config
    sqlite
    webkitgtk
  ];

  LIBSODIUM_USE_PKGCONFIG = "1";

  meta = {
    description = "Open source 2FA authenticator, with end-to-end encrypted backups.";
    longDescription = "Ente's 2FA app. An end-to-end encrypted, cross platform and free app for storing your 2FA codes with cloud backups. Works offline. You can even use it without signing up for an account if you don't want the cloud backups or multi-device sync.";
    homepage = "https://ente.io/";
    changelog = "https://github.com/ente-io/ente/releases/tag/auth-v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.zi3m5f ];
    platforms = lib.platforms.linux;
  };
}
