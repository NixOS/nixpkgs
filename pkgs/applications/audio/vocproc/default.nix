{
  lib,
  stdenv,
  fetchzip,
  pkg-config,
  lv2,
  fftw,
  lv2-cpp-tools,
  gtkmm2,
}:

stdenv.mkDerivation rec {
  pname = "vocproc";
  version = "0.2.1";

  src = fetchzip {
    url = "https://hyperglitch.com/files/vocproc/${pname}-${version}.default.tar.gz";
    sha256 = "07a1scyz14mg2jdbw6fpv4qg91zsw61qqii64n9qbnny9d5pn8n2";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    lv2
    fftw
    lv2-cpp-tools
    gtkmm2
  ];

  makeFlags = [
    "INSTALL_DIR=$(out)/lib/lv2"
  ];

  meta = with lib; {
    homepage = "https://hyperglitch.com/dev/VocProc";
    description = "An LV2 plugin for pitch shifting (with or without formant correction), vocoding, automatic pitch correction and harmonizing of singing voice (harmonizer)";
    license = licenses.gpl2;
    maintainers = [ maintainers.michalrus ];
    platforms = platforms.linux;
  };
}
