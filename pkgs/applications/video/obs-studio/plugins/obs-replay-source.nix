{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  obs-studio,
}:

stdenv.mkDerivation {
  pname = "obs-replay-source";
  version = "1.8.1-unstable-2026-09-23";

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-replay-source";
    rev = "842a48eaf74fdaa2a3236ba30c42cf574359970f";
    hash = "sha256-ZIG+jkq7TiZ+d+bektimPRg4E0YQPUjpowotDJHuigQ=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  postInstall = ''
    rm -rf $out/obs-plugins $out/data
  '';

  meta = {
    description = "Replay source for OBS studio";
    homepage = "https://github.com/exeldro/obs-replay-source";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      flexiondotorg
      pschmitt
    ];
  };
}
