{
  lib,
  stdenv,
  flutter332,
  rustPlatform,
  fetchFromGitHub,
  copyDesktopItems,
  mpv-unwrapped,
  webkitgtk_4_1,
  makeDesktopItem,
  writeText,
}:

let
  pname = "mangayomi";
  version = "0.6.35";

  src = fetchFromGitHub {
    owner = "kodjodevf";
    repo = "mangayomi";
    tag = "v${version}";
    hash = "sha256-XSXFo0+rLTUJ0p3F5+CvKD85OmrShb2xrpQK0F6fo2U=";
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
      stdenv.mkDerivation {
        pname = "rust_lib_mangayomi";
        inherit version src;
        inherit (src) passthru;

        postPatch =
          let
            fakeCargokitCmake = writeText "FakeCargokit.cmake" ''
              function(apply_cargokit target manifest_dir lib_name any_symbol_name)
                set("''${target}_cargokit_lib" ${rustDep}/${rustDep.passthru.libraryPath} PARENT_SCOPE)
              endfunction()
            '';
          in
          ''
            cp ${fakeCargokitCmake} rust_builder/cargokit/cmake/cargokit.cmake
          '';

        installPhase = ''
          runHook preInstall

          cp -r . "$out"

          runHook postInstall
        '';
      };
    flutter_discord_rpc_fork =
      { version, src, ... }:
      let
        flutter_discord_rpc_fork-rs = rustPlatform.buildRustPackage {
          pname = "flutter_discord_rpc_fork-rs";
          inherit version src;

          buildAndTestSubdir = "rust";

          cargoHash = "sha256-vYVg5ZALQDrolDtbbXm/epE5MmSKpRJbSU15VDiKh4U=";

          passthru.libraryPath = "lib/libflutter_discord_rpc_fork.so";
        };
      in
      stdenv.mkDerivation {
        pname = "flutter_discord_rpc_fork";
        inherit version src;
        inherit (src) passthru;

        postPatch =
          let
            fakeCargokitCmake = writeText "FakeCargokit.cmake" ''
              function(apply_cargokit target manifest_dir lib_name any_symbol_name)
                set("''${target}_cargokit_lib" ${flutter_discord_rpc_fork-rs}/${flutter_discord_rpc_fork-rs.passthru.libraryPath} PARENT_SCOPE)
              endfunction()
            '';
          in
          ''
            cp ${fakeCargokitCmake} cargokit/cmake/cargokit.cmake
          '';

        installPhase = ''
          runHook preInstall

          cp -r . "$out"

          runHook postInstall
        '';
      };
  };

  gitHashes = lib.importJSON ./gitHashes.json;

  nativeBuildInputs = [ copyDesktopItems ];

  buildInputs = [
    mpv-unwrapped
    webkitgtk_4_1
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
