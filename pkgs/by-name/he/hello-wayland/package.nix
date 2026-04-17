{
  stdenv,
  lib,
  fetchFromGitHub,
  imagemagick,
  pkg-config,
  wayland-scanner,
  wayland,
  wayland-protocols,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "hello-wayland";
  version = "0-unstable-2026-04-14";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "hello-wayland";
    rev = "14231ae0a7f12e0041e81f749ae509d07e88fbe5";
    hash = "sha256-9ciyfNnjBY3hg+UB7/xS7B30q9m3vvOc1emxi8qJTRE=";
  };

  separateDebugInfo = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    imagemagick
    pkg-config
    wayland-scanner
  ];
  buildInputs = [
    wayland
    wayland-protocols
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install hello-wayland $out/bin
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Hello world Wayland client";
    homepage = "https://github.com/emersion/hello-wayland";
    maintainers = with lib.maintainers; [ qyliss ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "hello-wayland";
  };
}
