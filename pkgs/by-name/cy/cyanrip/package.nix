{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  ffmpeg-headless,
  libcdio,
  libcdio-paranoia,
  libmusicbrainz,
  curl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cyanrip";
  version = "0.9.3.1";

  src = fetchFromGitHub {
    owner = "cyanreg";
    repo = "cyanrip";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GAPHsYQYJQOBV4ok7omqhiDPKX+VC4Bw3Msb3pd8Zo8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    ffmpeg-headless
    libcdio
    libcdio-paranoia
    libmusicbrainz
    curl
  ];

  meta = {
    homepage = "https://github.com/cyanreg/cyanrip";
    changelog = "https://github.com/cyanreg/cyanrip/releases/tag/${finalAttrs.src.rev}";
    description = "Bule-ish CD ripper";
    mainProgram = "cyanrip";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.zane ];
  };
})
