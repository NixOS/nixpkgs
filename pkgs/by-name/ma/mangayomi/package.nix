{
  lib,
  fetchFromGitHub,
  flutter,
  cargo,
  rustPlatform,
  mpv-unwrapped,
  xdg-user-dirs,
  zenity,
}:

let
  buildToolPubspecLock = lib.importJSON ./build-tool-pubspec.lock.json;
  mainPubspecLock = lib.importJSON ./pubspec.lock.json;
in

flutter.buildFlutterApplication rec {
  pname = "mangayomi";
  version = "0.3.55";

  src = fetchFromGitHub {
    owner = "kodjodevf";
    repo = "mangayomi";
    rev = "refs/tags/v${version}";
    hash = "sha256-16LLWJWkKzMNqVmxxgDF7SCOqtCeW2xBblJufda3UmI=";
  };

  patches = [
    ./cargokit.patch
  ];

  pubspecLock = lib.recursiveUpdate buildToolPubspecLock mainPubspecLock;

  gitHashes = {
    "flutter_qjs" = "sha256-l6uUUqiIkdD3ayUY9rUzxKXunlW2QU2sAuDd8fc2Iyc=";
    "flutter_windows_webview" = "sha256-lo8RwaInPa/dwD7Kay4edupOhNHdMTrMXy0f3XzRUgU=";
    "media_kit_libs_windows_video" = "sha256-SYVVOR6vViAsDH5MclInJk8bTt/Um4ccYgYDFrb5LBk=";
    "media_kit_native_event_loop" = "sha256-SYVVOR6vViAsDH5MclInJk8bTt/Um4ccYgYDFrb5LBk=";
    "media_kit_video" = "sha256-SYVVOR6vViAsDH5MclInJk8bTt/Um4ccYgYDFrb5LBk=";
  };

  cargoRoot = "rust";

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit pname version src;
    sourceRoot = "${src.name}/${cargoRoot}";
    hash = "sha256-efIfv/yZV6AFqJcdGQrFr24+gKUxX1xn+bRgPLwToP8=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
  ];

  buildInputs = [
    mpv-unwrapped
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=int-conversion";

  # use writable location for rust_builder instead of the store path made by pub2nix
  # this is also needed since patches don't get inherited by pub2nix
  preBuild = ''
    substituteInPlace .dart_tool/package_config.json \
        --replace-fail "file://${src}//rust_builder" "$(pwd)/rust_builder"
  '';

  postInstall = ''
    substituteInPlace linux/appimage/AppRun.desktop \
        --replace-fail "AppRun" "mangayomi"
    install -Dm644 linux/appimage/AppRun.desktop $out/share/applications/mangayomi.desktop
    install -Dm644 linux/appimage/AppRun.png $out/share/pixmaps/mangayomi.png
  '';

  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : $out/app/${pname}/lib \
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
