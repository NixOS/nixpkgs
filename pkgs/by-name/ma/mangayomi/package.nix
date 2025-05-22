{
  lib,
  fetchFromGitHub,
  flutter329,
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
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "kodjodevf";
    repo = "mangayomi";
    tag = "v${version}";
    hash = "sha256-kvwssyVjce9VipANRED5k3a2pdJRAhio6GtM7+5nd38=";
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

    cargoHash = "sha256-vGu5e5M6CFpaLodEpt8v8DGhu2S5h/E4vvqSNOKkWns=";

    passthru.libraryPath = "lib/librust_lib_mangayomi.so";

    meta = metaCommon;
  };
in
flutter329.buildFlutterApplication {
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

  gitHashes = {
    desktop_webview_window = "sha256-wRxQPlJZZe4t2C6+G5dMx3+w8scxWENLwII08dlZ4IA=";
    flutter_qjs = "sha256-m+Z0bCswylfd1E2Y6X6bdPivkSlXUxO4J0Icbco+/0A=";
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
