{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  fftwFloat,
}:

stdenv.mkDerivation rec {
  pname = "libspecbleach";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "lucianodato";
    repo = "libspecbleach";
    rev = "v${version}";
    sha256 = "sha256-Tw5nrGVAeoiMH00efJwcU+QLmKDZZTXHQPSV9x789TM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [
    fftwFloat
  ];

  meta = with lib; {
    description = "C library for audio noise reduction";
    homepage = "https://github.com/lucianodato/libspecbleach";
    license = licenses.lgpl2;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.unix;
  };
}
