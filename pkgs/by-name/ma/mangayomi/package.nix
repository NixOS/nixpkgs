{ lib
, stdenv
, fetchurl
, fetchFromGitHub
, flutter
, jq
, moreutils
, protobuf
, protoc-gen-prost
, protoc-gen-dart
, cargo
, rustc
, rustPlatform
, mpv-unwrapped
, webkitgtk_4_1
, xdg-user-dirs
, gnome
}:

let
  # Used inside media-kit
  # https://github.com/media-kit/media-kit/blob/main/libs/linux/media_kit_libs_linux/linux/CMakeLists.txt
  mimalloc-version = "2.1.2";
  mimalloc-tar = fetchurl {
    url = "https://github.com/microsoft/mimalloc/archive/refs/tags/v${mimalloc-version}.tar.gz";
    hash = "sha256-Kxv/b3F/lyXHC/jXnkeG2hPeiicAWeS6C90mKue+Rus=";
  };

  buildInfix = {
    "x86_64-linux" = "linux/x64";
    "aarch64-linux" = "linux/arm64";
    "x86_64-darwin" = "macos/x64";
    "aarch64-darwin" = "macos/arm64";
  }.${stdenv.system} or (throw "Unsupported system");

  mainPubspecLock = lib.importJSON ./pubspec.lock.json;
  cargokitBuildToolPubspecLock = lib.importJSON ./cargokit-build-tool-pubspec.lock.json;
in

flutter.buildFlutterApplication rec {
  pname = "mangayomi";
  version = "0.1.75";

  src = fetchFromGitHub {
    owner = "kodjodevf";
    repo = "mangayomi";
    rev = "v${version}";
    hash = "sha256-c2vK9RC4lMRJSDFkAC+tz56bMPOgp4Owyzeq+K8jPUc=";
  };

  postPatch = ''
    substituteInPlace linux/appimage/AppRun.desktop \
        --replace-fail "AppRun" "mangayomi"
  '';

  customSourceBuilders = {
    rinf = { version, src, ... }:
      stdenv.mkDerivation {
        pname = "rinf";
        inherit version src;
        inherit (src) passthru;

        patches = [ ./rinf.patch ];

        installPhase = ''
          runHook preInstall
          mkdir -p "$out"
          cp -r * "$out"
          runHook postInstall
        '';
      };
  };

  # build_tool hack part 1: join dependencies with the main package
  pubspecLock = lib.recursiveUpdate cargokitBuildToolPubspecLock mainPubspecLock;

  gitHashes = {
    background_downloader = "sha256-obZxr2nheh6jopGU+q73jyw5vFPMaZRmRMo8LyPb9RE=";
    flutter_windows_webview = "sha256-rVu+qQJxOQG+LDFCSO3ueg3aHmIFhPK2H51FTHhLTlg=";
    media_kit_video = "sha256-Kx0rr4x6sxPgfX3C5jjr8VYq0X/pPnjNDI/F/d41rVk=";
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
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-tKb4a9SrgPmRaK0VTZ8FN2GOdiw3FfXpE5D0l4qgs1k=";
  };

  # media-kit builds mimalloc from source
  preConfigure = ''
    install -D ${mimalloc-tar} build/${buildInfix}/release/mimalloc-${mimalloc-version}.tar.gz
  '';

  preBuild = ''
    # build_tool hack part 2: add build_tool as an actually resolvable package (the location is relative to the rinf package directory)
    jq '.packages += [.packages.[] | select(.name == "rinf") | .rootUri += "/cargokit/build_tool" | .name = "build_tool"]' .dart_tool/package_config.json | sponge .dart_tool/package_config.json
    # generate messages used by the main package
    packageRun rinf message
  '';

  postInstall = ''
    install -Dm644 linux/appimage/AppRun.desktop $out/share/applications/mangayomi.desktop
    install -Dm644 linux/appimage/AppRun.png $out/share/pixmaps/mangayomi.png
  '';

  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : $out/app/lib \
    --prefix PATH : ${lib.makeBinPath [ xdg-user-dirs gnome.zenity ]}
  '';

  meta = {
    changelog = "https://github.com/kodjodevf/mangayomi/releases/tag/${src.rev}";
    description = "Free and open source application for reading manga and watching anime";
    homepage = "https://github.com/kodjodevf/mangayomi";
    license = lib.licenses.asl20;
    mainProgram = "mangayomi";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
