{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libltc,
  libsndfile,
  jack2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ltc-tools";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "x42";
    repo = "ltc-tools";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VBFMRp/mCDVb+XJI5WQY1PKXh4mN6N9s2TBkcNIq4m4=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libltc
    libsndfile
    jack2
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://github.com/x42/ltc-tools";
    description = "Tools to deal with linear-timecode (LTC)";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ tg-x ];
  };
})
