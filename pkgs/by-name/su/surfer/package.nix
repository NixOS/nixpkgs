{
  lib,
  fetchFromGitLab,
  rustPlatform,
  pkg-config,
  openssl,
  wayland,
  autoPatchelfHook,
  libxkbcommon,
  libGL,
  libX11,
  libXcursor,
  libXi,
  libiconv,
  stdenv,
  makeWrapper,
  darwin,
  writeDarwinBundle,
  zenity,
}:
rustPlatform.buildRustPackage rec {
  pname = "surfer";
  version = "0.2.0";

  src = fetchFromGitLab {
    owner = "surfer-project";
    repo = "surfer";
    rev = "v${version}";
    hash = "sha256-C5jyWLs7fdEn2oW5BORZYazQwjXNxf8ketYFwlVkHpA";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  buildInputs = [
    openssl
    stdenv.cc.cc.lib
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin (
    [ libiconv ]
    ++ (with darwin.apple_sdk.frameworks; [
      SystemConfiguration
      Security
      AppKit
      Foundation
      CoreFoundation
      OpenGL
      CoreServices
      QuartzCore
      ApplicationServices
      CoreGraphics
      CoreVideo
      Carbon
      CoreData
    ]));

  # Wayland and X11 libs are required at runtime since winit uses dlopen
  runtimeDependencies = [
    wayland
    libxkbcommon
    libGL
    libX11
    libXcursor
    libXi
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "codespan-0.12.0" = "sha256-3F2006BR3hyhxcUTaQiOjzTEuRECKJKjIDyXonS/lrE=";
      "egui_skia-0.5.0" = "sha256-dpkcIMPW+v742Ov18vjycLDwnn1JMsvbX6qdnuKOBC4=";
      "tracing-tree-0.2.0" = "sha256-/JNeAKjAXmKPh0et8958yS7joORDbid9dhFB0VUAhZc=";
    };
  };

  # Avoid the network attempt from skia. See: https://github.com/cargo2nix/cargo2nix/issues/318
  doCheck = false;

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/surfer \
      --prefix PATH : ${lib.makeBinPath [ zenity ]}
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p "$out/Applications/Surfer.app/Contents/MacOS"

    ${writeDarwinBundle}/bin/write-darwin-bundle "$out" "Surfer" "unused"
    mv $out/bin/surfer $out/Applications/Surfer.app/Contents/MacOS/Surfer
    wrapProgram $out/Applications/Surfer.app/Contents/MacOS/Surfer \
      --prefix PATH : ${lib.makeBinPath [ zenity ]}
    ln -s $out/Applications/Surfer.app/Contents/MacOS/Surfer $out/bin/surfer
  '';

  meta = {
    description = "Extensible and Snappy Waveform Viewer";
    homepage = "https://surfer-project.org/";
    changelog = "https://gitlab.com/surfer-project/surfer/-/releases/v${version}";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ hakan-demirli ];
    platforms = lib.platforms.unix;
    mainProgram = "surfer";
  };
}
