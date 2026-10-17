{
  stdenv,
  lib,
  fetchFromGitHub,
  libx11,
  cairo,
  lv2,
  libsndfile,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "boops";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = "BOops";
    tag = finalAttrs.version;
    hash = "sha256-OavZHplHAZ0iiLCm2CYbX5WY/SVa2m7STyg8VCZXd1s=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libx11
    cairo
    lv2
    libsndfile
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://github.com/sjaehn/BOops";
    description = "Sound glitch effect sequencer LV2 plugin";
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
  };
})
