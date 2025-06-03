{
  lib,
  fetchFromGitHub,
  flutter324,
  buildGoModule,
  libayatana-appindicator,
  makeDesktopItem,
  copyDesktopItems,
  autoPatchelfHook,
}:

let
  metaCommon = {
    description = "Multi-platform auto-proxy client, supporting Sing-box, X-ray, TUIC, Hysteria, Reality, Trojan, SSH etc";
    license = with lib.licenses; [
      unfree # upstream adds non-free additional conditions. https://github.com/hiddify/hiddify-app/blob/0f6b15057f626016fcd7a0c075f1c8c2f606110a/LICENSE.md#additional-conditions-to-gpl-v3
      gpl3Only
    ];
    maintainers = with lib.maintainers; [ ];
  };

  libcore = buildGoModule rec {
    pname = "hiddify-core";
    version = "3.1.8";

    src = fetchFromGitHub {
      owner = "hiddify";
      repo = "hiddify-core";
      tag = "v${version}";
      hash = "sha256-NRzzkC3xbRVP20Pm29bHf8YpxmnjISgF46c8l9qU4rA=";
    };

    vendorHash = "sha256-a7NFZt4/w2+oaZG3ncaOrrhASxUptcWS/TeaIQrgLe4=";

    GO_BUILD_FLAGS = ''
      -tags "with_gvisor,with_quic,with_wireguard,with_ech,with_utls,with_clash_api,with_grpc" \
      -trimpath \
      -ldflags "-s -w" \
    '';

    buildPhase = ''
      runHook preBuild

      go build ${GO_BUILD_FLAGS} -buildmode=c-shared -o bin/lib/libcore.so ./custom
      mkdir lib
      cp bin/lib/libcore.so ./lib/libcore.so
      CGO_LDFLAGS="./lib/libcore.so" go build ${GO_BUILD_FLAGS} -o bin/HiddifyCli ./cli/bydll

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      install -Dm0755 bin/HiddifyCli $out/bin/HiddifyCli
      install -Dm0755 lib/libcore.so $out/lib/libcore.so

      runHook postInstall
    '';

    meta = metaCommon // {
      homepage = "https://github.com/hiddify/hiddify-core";
      mainProgram = "HiddifyCli";
    };
  };
in
flutter324.buildFlutterApplication {
  pname = "hiddify-app";
  version = "2.5.7-unstable-2025-01-06";

  src = fetchFromGitHub {
    owner = "hiddify";
    repo = "hiddify-app";
    rev = "a7547d298a5f8058446b6a470e56fe4efa3c1ccd";
    hash = "sha256-5I/k2KxdWiNsgwJY+bqMVqtC2eGshKbpLYzsPrmvhmY=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    circle_flags = "sha256-dqORH4yj0jU8r9hP9NTjrlEO0ReHt4wds7BhgRPq57g=";
    flutter_easy_permission = "sha256-fs2dIwFLmeDrlFIIocGw6emOW1whGi9W7nQ7mHqp8R0=";
    humanizer = "sha256-zsDeol5l6maT8L8R6RRtHyd7CJn5908nvRXIytxiPqc=";
  };

  postPatch = ''
    substituteInPlace linux/my_application.cc \
      --replace-fail "./hiddify.png" "${placeholder "out"}/share/pixmaps/hiddify.png"
  '';

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [
    libayatana-appindicator
  ];

  preBuild = ''
    mkdir -p libcore/bin
    cp -r ${libcore}/lib libcore/bin/lib
    cp ${libcore}/bin/HiddifyCli libcore/bin/HiddifyCli
    packageRun build_runner build --delete-conflicting-outputs
    packageRun slang
  '';

  flutterBuildFlags = [
    "--target lib/main_prod.dart"
  ];

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

  postInstall = ''
    install -Dm0644 assets/images/source/ic_launcher_border.png $out/share/pixmaps/hiddify.png
  '';

  preFixup = ''
    patchelf --shrink-rpath --allowed-rpath-prefixes "$NIX_STORE" $out/app/hiddify-app/lib/lib*.so
  '';

  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : $out/app/hiddify-app/lib
  '';

  meta = metaCommon // {
    homepage = "https://hiddify.com";
    mainProgram = "hiddify";
    platforms = lib.platforms.linux;
  };
}
