{ stdenv, lib, fetchFromGitHub
, cmake, pkg-config, fftwFloat, libsamplerate
}:

stdenv.mkDerivation rec {
  pname = "csdr";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "jketterl";
    repo = pname;
    rev = version;
    sha256 = "sha256-4XO3QYF0yaMNFjBHulrlZvO0/A1fFscD98QxnC6Itmk=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  propagatedBuildInputs = [
    fftwFloat
    libsamplerate
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://github.com/jketterl/csdr";
    description = "A simple DSP library and command-line tool for Software Defined Radio";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = teams.c3d2.members;
  };
}
