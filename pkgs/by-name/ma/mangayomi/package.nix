{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  flutter,
  jq,
  moreutils,
  protobuf,
  protoc-gen-prost,
  protoc-gen-dart,
  cargo,
  rustc,
  rustPlatform,
  mpv-unwrapped,
  webkitgtk_4_1,
  xdg-user-dirs,
  zenity,
  jdk,
}:

let
  # Used inside media-kit
  # https://github.com/media-kit/media-kit/blob/main/libs/linux/media_kit_libs_linux/linux/CMakeLists.txt
  mimalloc-version = "2.1.2";
  mimalloc-tar = fetchurl {
    url = "https://github.com/microsoft/mimalloc/archive/refs/tags/v${mimalloc-version}.tar.gz";
    hash = "sha256-Kxv/b3F/lyXHC/jXnkeG2hPeiicAWeS6C90mKue+Rus=";
  };

  buildInfix =
    {
      "x86_64-linux" = "linux/x64";
      "aarch64-linux" = "linux/arm64";
      "x86_64-darwin" = "macos/x64";
      "aarch64-darwin" = "macos/arm64";
    }
    .${stdenv.system} or (throw "Unsupported system");

in

flutter.buildFlutterApplication rec {
  pname = "mangayomi";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "kodjodevf";
    repo = "mangayomi";
    rev = "refs/tags/v${version}";
    hash = "sha256-TvUprEdqLzQT8zJfUOXXQb1MW93pTjyNiPQtKi629Gk=";
  };

  postPatch = ''
    substituteInPlace linux/appimage/AppRun.desktop \
        --replace-fail "AppRun" "mangayomi"
  '';

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    "desktop_webview_window" = "sha256-PTZmKorYXLOITMBXNbyY6Gow2FMemV3j6LVaaZr7VnY=";
    "flutter_qjs" = "sha256-l6uUUqiIkdD3ayUY9rUzxKXunlW2QU2sAuDd8fc2Iyc=";
    "flutter_windows_webview" = "sha256-lo8RwaInPa/dwD7Kay4edupOhNHdMTrMXy0f3XzRUgU=";
    "media_kit_libs_windows_video" = "sha256-aKW7HHiBP1IIKQ+v6QGtYSimQIbJ+43cU8xn6VoJb38=";
    "media_kit_native_event_loop" = "sha256-aKW7HHiBP1IIKQ+v6QGtYSimQIbJ+43cU8xn6VoJb38=";
    "media_kit_video" = "sha256-aKW7HHiBP1IIKQ+v6QGtYSimQIbJ+43cU8xn6VoJb38=";
  };

  nativeBuildInputs = [
    jq
    moreutils # sponge
    protobuf
    protoc-gen-prost
    protoc-gen-dart
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    mpv-unwrapped
    webkitgtk_4_1
    jdk
  ];

  cargoRoot = "rust";

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit pname version src;
    sourceRoot = "${src.name}/${cargoRoot}";
    hash = "sha256-zlhhyo01mMRo2JRbMVKNcFFT9JkcDmOCLjwY4xCiD6M=";
  };

  # media-kit builds mimalloc from source
  preConfigure = ''
    install -D ${mimalloc-tar} build/${buildInfix}/release/mimalloc-${mimalloc-version}.tar.gz
  '';

  preBuild = ''
    # build_tool hack part 2: add build_tool as an actually resolvable package (the location is relative to the rinf package directory)
    #jq '.packages += [.packages.[] | select(.name == "rinf") | .rootUri += "/cargokit/build_tool" | .name = "build_tool"]' .dart_tool/package_config.json | sponge .dart_tool/package_config.json
    # generate messages used by the main package
    #packageRun rinf message
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-error=int-conversion";

  postInstall = ''
    install -Dm644 linux/appimage/AppRun.desktop $out/share/applications/mangayomi.desktop
    install -Dm644 linux/appimage/AppRun.png $out/share/pixmaps/mangayomi.png
  '';

  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : $out/app/lib \
    --prefix PATH : ${
      lib.makeBinPath [
        xdg-user-dirs
        zenity
      ]
    }
  '';

  meta = {
    changelog = "https://github.com/kodjodevf/mangayomi/releases/tag/v${version}";
    description = "Free and open source application for reading manga and watching anime";
    homepage = "https://github.com/kodjodevf/mangayomi";
    license = lib.licenses.asl20;
    mainProgram = "mangayomi";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
