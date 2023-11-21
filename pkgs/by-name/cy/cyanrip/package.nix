{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, pkg-config
, ffmpeg-headless
, libcdio
, libcdio-paranoia
, libmusicbrainz5
, curl
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cyanrip";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "cyanreg";
    repo = "cyanrip";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sWgHf8S4GZDAIvMUf5KvGy2y0JcUbRS53IjArdgokqc=";
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
    libmusicbrainz5
    curl
  ];

  meta = with lib; {
    homepage = "https://github.com/cyanreg/cyanrip";
    description = "Bule-ish CD ripper";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.zane ];
  };
})
