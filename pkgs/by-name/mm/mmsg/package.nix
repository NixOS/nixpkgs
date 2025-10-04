{
  lib,
  pkg-config,
  wayland,
  wayland-scanner,
  stdenv,
  fetchFromGitHub,
}: # 6066d37d810bb16575c0b60e25852d1f6d50de60
stdenv.mkDerivation {
  pname = "mmsg";
  version = "mangowc-v0.8.9";

  src = fetchFromGitHub {
    owner = "DreamMaoMao";
    repo = "mmsg";
    rev = "6066d37d810bb16575c0b60e25852d1f6d50de60";
    hash = "sha256-xiQGpk987dCmeF29mClveaGJNIvljmJJ9FRHVPp92HU=";
  };

  # This MUST match what's on the flake input for mangowc. Feel free to improve.

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
  ];

  installPhase = ''
    install -D mmsg $out/bin/mmsg
  '';

  meta = {
    description = "mangowc ipc client";
    homepage = "https://github.com/DreamMaoMao/mmsg";
    maintainers = with lib.maintainers; [ hustlerone ];
    mainProgram = "mmsg";
    platforms = lib.platforms.all;
  };
}
