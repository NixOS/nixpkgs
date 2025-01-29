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
  stdenv,
  darwin,
  makeWrapper,
  zenity,
}:
rustPlatform.buildRustPackage rec {
  pname = "surfer";
  version = "0.3.0";

  src = fetchFromGitLab {
    owner = "surfer-project";
    repo = "surfer";
    rev = "v${version}";
    hash = "sha256-mvHyljAEVi1FMkEbKsPmCNx2Cg0/Ydw3ZQCZsowEKGc=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      openssl
      (lib.getLib stdenv.cc.cc)
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.AppKit ];

  # Wayland and X11 libs are required at runtime since winit uses dlopen
  runtimeDependencies = lib.optionals stdenv.hostPlatform.isLinux [
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
      "egui_skia_renderer-0.2.0" = "sha256-1l8iluTHDYZGRkKWnurRMj4iHljogPWs26pzkUtIGwY=";
      "spade-0.10.0" = "sha256-nl9MsrV68mE7hVEBFF/WdasUXCJoUazCFg4xG+2MOEY=";
    };
  };

  # Avoid the network attempt from skia. See: https://github.com/cargo2nix/cargo2nix/issues/318
  doCheck = false;

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/surfer \
      --prefix PATH : ${lib.makeBinPath [ zenity ]}
  '';

  meta = {
    description = "Extensible and Snappy Waveform Viewer";
    homepage = "https://surfer-project.org/";
    changelog = "https://gitlab.com/surfer-project/surfer/-/releases/v${version}";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ hakan-demirli ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "surfer";
  };
}
