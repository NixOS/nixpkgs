{
  stdenv,
  lib,
  fetchFromGitHub,
  libx11,
  cairo,
  cpio,
  lv2,
  libsndfile,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bvibratr";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = "BVibratr";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    sha256 = "sha256-bm4RKyLPR5WL52wXJ8w4YUZ1t9WoqYAw5ApMASVmiAQ=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libx11
    cairo
    cpio
    lv2
    libsndfile
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://github.com/sjaehn/BVibratr";
    description = "Flavoured vibrato as an instrument LV2 plugin";
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
  };
})
