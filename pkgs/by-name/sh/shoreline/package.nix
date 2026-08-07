{
  stdenv,
  lib,
  pkg-config,
  imagemagick,
  fetchFromGitHub,
  SDL2,
  numactl,
  libvncserver,
  freetype,
  unstableGitUpdater,
}:
stdenv.mkDerivation {
  pname = "shoreline";
  version = "0-unstable-2021-08-24";

  src = fetchFromGitHub {
    owner = "TobleMiner";
    repo = "shoreline";
    rev = "05a2bbfb4559090727c51673e1fb47d20eac5672";
    hash = "sha256-fWzk1gM8vmqkM9hwl6Jnut2AAMQQ91hAYu41xgoI1Jk=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    SDL2
    numactl
    libvncserver
    freetype
  ];

  installPhase = ''
    runHook preInstall
    install -m755 -D shoreline $out/bin/shoreline
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    description = "Very fast (200+ Gbit/s) pixelflut server written in C with full IPv6 support";
    homepage = "https://github.com/TobleMiner/shoreline";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zebreus ];
    platforms = lib.platforms.linux;
    mainProgram = "shoreline";
  };
}
