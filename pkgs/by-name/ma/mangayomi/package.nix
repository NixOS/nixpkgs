{
  lib,
  stdenv,
  flutter335,
  rustPlatform,
  fetchFromGitHub,
  copyDesktopItems,
  alsa-lib,
  mpv-unwrapped,
  webkitgtk_4_1,
  makeDesktopItem,
  writeText,
}:

let
  pname = "mangayomi";
  version = "0.6.70";

  src = fetchFromGitHub {
    owner = "kodjodevf";
    repo = "mangayomi";
    tag = "v${version}";
    hash = "sha256-XWa5jEIQWmApbXNu8AgKt6Af9S1ZrsyaFET07FVn7Rc=";
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

    cargoHash = "sha256-3q+fI0MHg+wSSkbEzqXxdoGkF0B/LhLMbB6VcX3xuwE=";

    passthru.libraryPath = "lib/librust_lib_mangayomi.so";

    meta = metaCommon;
  };
in
flutter335.buildFlutterApplication {
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

          cargoHash = "sha256-oJOM/Tb4QrezdtU8YTyr57JZp5FkDewgwXrBqwp6cp8=";

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
    alsa-lib
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
