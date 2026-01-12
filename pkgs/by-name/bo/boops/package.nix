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

stdenv.mkDerivation rec {
  pname = "boops";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = "BOops";
    tag = version;
    sha256 = "0nvpawk58g189z96xnjs4pyri5az3ckdi9mhi0i9s0a7k4gdkarr";
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
}
