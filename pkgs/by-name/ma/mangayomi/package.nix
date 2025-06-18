{
  lib,
  fetchFromGitHub,
  flutter332,
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
  version = "0.6.25";

  src = fetchFromGitHub {
    owner = "kodjodevf";
    repo = "mangayomi";
    tag = "v${version}";
    hash = "sha256-vuikoTyvUESz9ZESo4gy76syLYVO1WZdvoJf6NsyW4Y=";
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

    cargoHash = "sha256-DDHBLQWscORg4+0CX5c2wmrhm2t7wOpotZFB+85w+EA=";

    passthru.libraryPath = "lib/librust_lib_mangayomi.so";

    meta = metaCommon;
  };
in
flutter332.buildFlutterApplication {
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
    flutter_qjs = "sha256-uF3+lQyc6oXWjg9xm8PVXRNZ3AXrw7+FH/lPIQPzaJY=";
    flutter_web_auth_2 = "sha256-3aci73SP8eXg6++IQTQoyS+erUUuSiuXymvR32sxHFw=";
    epubx = "sha256-Rf9zaabPvP7D4NgyJ+LpSB8zHjBvhq2wE0p9Sy7uOXM=";
    media_kit_video = "sha256-t8lqS44lylLhMyvlY5G1k7EXfpDq8WshBVg8D/z0Hbc=";
    re_editor = "sha256-alfzTs9lUHTsaZgXADb1X3T4ZB6KrhIEeGY0wuvZJtU=";
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
