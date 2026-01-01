{
  lib,
  stdenv,
<<<<<<< HEAD
  flutter338,
  rustPlatform,
  fetchFromGitHub,
  copyDesktopItems,
  alsa-lib,
=======
  flutter332,
  rustPlatform,
  fetchFromGitHub,
  copyDesktopItems,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  mpv-unwrapped,
  webkitgtk_4_1,
  makeDesktopItem,
  writeText,
}:

let
  pname = "mangayomi";
<<<<<<< HEAD
  version = "0.6.85";
=======
  version = "0.6.35";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "kodjodevf";
    repo = "mangayomi";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Zy4B0nl9R/LmXj/DUI4v98GbSUu8YWGOO0GCXpRHtBA=";
=======
    hash = "sha256-XSXFo0+rLTUJ0p3F5+CvKD85OmrShb2xrpQK0F6fo2U=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  metaCommon = {
    changelog = "https://github.com/kodjodevf/mangayomi/releases/tag/v${version}";
    description = "Reading manga, novels, and watching animes";
    homepage = "https://github.com/kodjodevf/mangayomi";
    license = with lib.licenses; [ asl20 ];
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };

  rustDep = rustPlatform.buildRustPackage {
    inherit pname version src;

    sourceRoot = "${src.name}/rust";

<<<<<<< HEAD
    cargoHash = "sha256-3q+fI0MHg+wSSkbEzqXxdoGkF0B/LhLMbB6VcX3xuwE=";
=======
    cargoHash = "sha256-DDHBLQWscORg4+0CX5c2wmrhm2t7wOpotZFB+85w+EA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    passthru.libraryPath = "lib/librust_lib_mangayomi.so";

    meta = metaCommon;
  };
in
<<<<<<< HEAD
flutter338.buildFlutterApplication {
=======
flutter332.buildFlutterApplication {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
          cargoHash = "sha256-oJOM/Tb4QrezdtU8YTyr57JZp5FkDewgwXrBqwp6cp8=";
=======
          cargoHash = "sha256-vYVg5ZALQDrolDtbbXm/epE5MmSKpRJbSU15VDiKh4U=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

  gitHashes = lib.importJSON ./git-hashes.json;

  nativeBuildInputs = [ copyDesktopItems ];

  buildInputs = [
<<<<<<< HEAD
    alsa-lib
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
