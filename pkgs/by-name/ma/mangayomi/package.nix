{
  lib,
  fetchFromGitHub,
  flutter327,
  webkitgtk_4_1,
  mpv,
  rustPlatform,
  stdenv,
  copyDesktopItems,
  makeDesktopItem,
  replaceVars,
}:
let
  pname = "mangayomi";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "kodjodevf";
    repo = "mangayomi";
    tag = "v${version}";
    hash = "sha256-tZioUn0mTY3Otj3TEdwhK2wqJqvq6WkU183NfFpo0WM=";
  };

  metaCommon = {
    changelog = "https://github.com/kodjodevf/mangayomi/releases/tag/v${version}";
    description = "Read manga and stream anime from a variety of sources including BitTorrent";
    homepage = "https://github.com/kodjodevf/mangayomi";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ aucub ];
    platforms = lib.platforms.linux;
  };

  rustDep = rustPlatform.buildRustPackage {
    inherit pname version src;

    sourceRoot = "${src.name}/rust";

    useFetchCargoVendor = true;

    cargoHash = "sha256-WkWNgjTA50cOztuF9ZN6v8l38kldarqUOMXNFJDI0Ds=";

    passthru.libraryPath = "lib/librust_lib_mangayomi.so";

    meta = metaCommon;
  };
in
flutter327.buildFlutterApplication {
  inherit
    pname
    version
    src
    rustDep
    ;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  customSourceBuilders = {
    rust_lib_mangayomi =
      { version, src, ... }:
      stdenv.mkDerivation rec {
        pname = "rust_lib_mangayomi";
        inherit version src;
        inherit (src) passthru;

        patches = [
          (replaceVars ./cargokit.patch {
            output_lib = "${rustDep}/${rustDep.passthru.libraryPath}";
          })
        ];

        installPhase = ''
          runHook preInstall

          cp -r . $out

          runHook postInstall
        '';
      };
  };

  gitHashes = {
    desktop_webview_window = "sha256-wRxQPlJZZe4t2C6+G5dMx3+w8scxWENLwII08dlZ4IA=";
    flutter_qjs = "sha256-m+Z0bCswylfd1E2Y6X6bdPivkSlXUxO4J0Icbco+/0A=";
    media_kit_libs_windows_video = "sha256-bRwDrK6YdQGuXnxyIaNtvRoubl3i42ksaDsggAwgB80=";
    media_kit_video = "sha256-bRwDrK6YdQGuXnxyIaNtvRoubl3i42ksaDsggAwgB80=";
    media_kit = "sha256-bRwDrK6YdQGuXnxyIaNtvRoubl3i42ksaDsggAwgB80=";
  };

  nativeBuildInputs = [
    copyDesktopItems
  ];

  buildInputs = [
    webkitgtk_4_1
    mpv
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "mangayomi";
      exec = "mangayomi";
      icon = "mangayomi";
      genericName = "Mangayomi";
      desktopName = "Mangayomi";
      categories = [
        "Utility"
      ];
      keywords = [
        "Manga"
        "Anime"
        "BitTorrent"
      ];
    })
  ];

  postInstall = ''
    install -Dm644 assets/app_icons/icon-red.png $out/share/pixmaps/mangayomi.png
  '';

  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : $out/app/mangayomi/lib
  '';

  passthru.updateScript = ./update.sh;

  meta = metaCommon // {
    mainProgram = "mangayomi";
  };
}
