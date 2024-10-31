{
  lib,
  fetchFromGitHub,
  pkg-config,
  flutter,
  buildGoModule,
  libayatana-appindicator,
  stdenv,
  fetchurl,
  makeDesktopItem,
  copyDesktopItems,
  wrapGAppsHook3,
  autoPatchelfHook,
}:
let
  pname = "hiddify-app";
  version = "2.5.7-unstable-2024-10-30";
  src = fetchFromGitHub {
    owner = "hiddify";
    repo = "hiddify-app";
    rev = "0144cddf670df11d1586a0dc76483f4c4f5b4230";
    hash = "sha256-bjZkc0H0409YxM6AGrhm6gPaKNj/9SiVs0AUPoLJX+o=";
    fetchSubmodules = true;
  };
  libcore = buildGoModule rec {
    inherit pname version src;

    modRoot = "./libcore";

    vendorHash = "sha256-a7NFZt4/w2+oaZG3ncaOrrhASxUptcWS/TeaIQrgLe4=";

    GO_PUBLIC_FLAGS = ''
      -tags "with_gvisor,with_quic,with_wireguard,with_ech,with_utls,with_clash_api,with_grpc" \
      -trimpath \
      -ldflags "-s -w" \
    '';

    postPatch = ''
      sed -i '/import (/a\ \t"os"\n\t"path/filepath"' ./libcore/v2/db/hiddify_db.go
      substituteInPlace ./libcore/v2/db/hiddify_db.go \
        --replace-fail 'NewGoLevelDBWithOpts(name, "./data", ' 'NewGoLevelDBWithOpts(name, filepath.Join(os.Getenv("HOME"), ".local", "share", "app.hiddify.com", "data"), '
    '';

    buildPhase = ''
      runHook preBuild

      go build ${GO_PUBLIC_FLAGS} -buildmode=c-shared -o bin/lib/libcore.so ./custom
      mkdir lib
      cp bin/lib/libcore.so ./lib/libcore.so
      CGO_LDFLAGS="./lib/libcore.so" go build ${GO_PUBLIC_FLAGS} -o bin/HiddifyCli ./cli/bydll

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/lib
      cp ./bin/HiddifyCli $out/bin/HiddifyCli
      cp ./lib/libcore.so $out/lib/libcore.so

      runHook postInstall
    '';

    meta = {
      description = "Multi-platform auto-proxy client, supporting Sing-box, X-ray, TUIC, Hysteria, Reality, Trojan, SSH etc";
      homepage = "https://hiddify.com";
      mainProgram = "HiddifyCli";
      license = lib.licenses.cc-by-nc-sa-40;
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [ aucub ];
    };
  };
  sqlite-autoconf = fetchurl {
    url = "https://sqlite.org/2024/sqlite-autoconf-3460000.tar.gz";
    hash = "sha256-b45qezNSc3SIFvmztiu9w3Koid6HgtfwSMZTpEdBen0=";
  };
in
flutter.buildFlutterApplication {
  inherit pname version src;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  buildInputs = [
    libayatana-appindicator
  ];

  nativeBuildInputs = [
    pkg-config
    autoPatchelfHook
    wrapGAppsHook3
    copyDesktopItems
  ];

  customSourceBuilders = {
    sqlite3_flutter_libs =
      { version, src, ... }:
      stdenv.mkDerivation rec {
        pname = "sqlite3_flutter_libs";
        inherit version src;
        inherit (src) passthru;
        postPatch = ''
          substituteInPlace linux/CMakeLists.txt \
            --replace-fail "https://sqlite.org/2024/sqlite-autoconf-3460000.tar.gz" "file://${sqlite-autoconf}"
        '';
        installPhase = ''
          runHook preInstall
          mkdir $out
          cp -a ./* $out/
          runHook postInstall
        '';
      };
  };

  postPatch = ''
    substituteInPlace ./linux/my_application.cc \
      --replace-fail "./hiddify.png" "${placeholder "out"}/share/pixmaps/hiddify.png"
  '';

  preBuild = ''
    cp -r ${libcore}/lib libcore/bin/lib
    cp ${libcore}/bin/HiddifyCli libcore/bin/HiddifyCli
    packageRun build_runner build --delete-conflicting-outputs
    packageRun slang
  '';

  postInstall = ''
    mkdir -p $out/share/pixmaps/
    cp ./assets/images/source/ic_launcher_border.png $out/share/pixmaps/hiddify.png
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "hiddify";
      exec = "hiddify";
      icon = "hiddify";
      genericName = "Hiddify";
      desktopName = "Hiddify";
      categories = [
        "Network"
      ];
      keywords = [
        "Hiddify"
        "Proxy"
        "VPN"
        "V2ray"
        "Nekoray"
        "Xray"
        "Psiphon"
        "OpenVPN"
      ];
    })
  ];

  flutterBuildFlags = [
    "--target lib/main_prod.dart"
  ];

  gitHashes = {
    circle_flags = "sha256-dqORH4yj0jU8r9hP9NTjrlEO0ReHt4wds7BhgRPq57g=";
    flutter_easy_permission = "sha256-fs2dIwFLmeDrlFIIocGw6emOW1whGi9W7nQ7mHqp8R0=";
    humanizer = "sha256-zsDeol5l6maT8L8R6RRtHyd7CJn5908nvRXIytxiPqc=";
  };

  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : "$out/app/${pname}/lib"
  '';

  preFixup = ''
    patchelf --shrink-rpath --allowed-rpath-prefixes "$NIX_STORE" $out/app/${pname}/lib/lib*.so
  '';

  meta = {
    description = "Multi-platform auto-proxy client, supporting Sing-box, X-ray, TUIC, Hysteria, Reality, Trojan, SSH etc";
    homepage = "https://hiddify.com";
    mainProgram = "hiddify";
    license = lib.licenses.cc-by-nc-sa-40;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ aucub ];
  };
}
