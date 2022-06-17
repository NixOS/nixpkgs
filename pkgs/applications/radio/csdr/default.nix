{ stdenv, lib, fetchFromGitHub
, autoreconfHook, pkg-config, fftwFloat, libsamplerate
}:

stdenv.mkDerivation rec {
  pname = "csdr";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "jketterl";
    repo = pname;
    rev = version;
    sha256 = "1vip5a3xgskcwba3xi66zfr986xrsch9na7my818cm8vw345y57b";
  };

  patchPhase = ''
    substituteInPlace configure.ac \
      --replace -Wformat=0 ""
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    fftwFloat
    libsamplerate
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://github.com/jketterl/csdr";
    description = "A simple DSP library and command-line tool for Software Defined Radio";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ astro ];
  };
}
