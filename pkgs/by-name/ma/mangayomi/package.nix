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
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "kodjodevf";
    repo = "mangayomi";
    tag = "v${version}";
    hash = "sha256-xF3qvmEGctYXE7HWka89G4W6ytMTVGw75o26h/Ql0Aw=";
  };

  metaCommon = {
    changelog = "https://github.com/kodjodevf/mangayomi/releases/tag/v${version}";
    description = "Reading manga, novels, and watching animes";
    homepage = "https://github.com/kodjodevf/mangayomi";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ ];
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
  inherit pname version src;

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

  gitHashes =
    let
      media_kit-hash = "sha256-bRwDrK6YdQGuXnxyIaNtvRoubl3i42ksaDsggAwgB80=";
    in
    {
      desktop_webview_window = "sha256-wRxQPlJZZe4t2C6+G5dMx3+w8scxWENLwII08dlZ4IA=";
      flutter_qjs = "sha256-m+Z0bCswylfd1E2Y6X6bdPivkSlXUxO4J0Icbco+/0A=";
      media_kit_libs_windows_video = media_kit-hash;
      media_kit_video = media_kit-hash;
      media_kit = media_kit-hash;
      flutter_web_auth_2 = "sha256-3aci73SP8eXg6++IQTQoyS+erUUuSiuXymvR32sxHFw=";
    };

  nativeBuildInputs = [ copyDesktopItems ];

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

  passthru = {
    inherit rustDep;
    updateScript = ./update.sh;
  };

  meta = metaCommon // {
    mainProgram = "mangayomi";
  };
}
