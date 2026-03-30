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
  version = "0-unstable-2026-03-17";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "hello-wayland";
    rev = "9a64c5ce78d004dc50814361b5153cef071f7042";
    hash = "sha256-YSdBY0IJQB7iyiunVikFHd0S2GlPy7cZBl+aQkpCY1s=";
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
