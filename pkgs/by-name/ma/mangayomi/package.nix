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
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "kodjodevf";
    repo = "mangayomi";
    rev = "refs/tags/v${version}";
    hash = "sha256-yrLaytLdGt7UIcAsLxmDks90uSFgfwFuoigcRCGLj78=";
  };

  postPatch = ''
    substituteInPlace linux/appimage/AppRun.desktop \
        --replace-fail "AppRun" "mangayomi"
  '';

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = { };

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

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit pname version src;
    hash = "sha256-9xUQEItdeebN/gSS3e/6fJhrqpk5cPsR7fxckiCQM4A=";
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

  #env.NIX_CFLAGS_COMPILE = "-Wno-error=int-conversion";

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
