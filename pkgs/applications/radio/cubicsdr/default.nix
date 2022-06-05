{ lib, stdenv, fetchFromGitHub, cmake, fftw, hamlib, libpulseaudio, libGL, libX11, liquid-dsp,
  pkg-config, soapysdr-with-plugins, wxGTK31-gtk3, enableDigitalLab ? false }:

stdenv.mkDerivation rec {
  pname = "cubicsdr";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "cjcliffe";
    repo = "CubicSDR";
    rev = version;
    sha256 = "0cyv1vk97x4i3h3hhh7dx8mv6d1ad0fypdbx5fl26bz661sr8j2n";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ fftw hamlib libpulseaudio libGL libX11 liquid-dsp soapysdr-with-plugins wxGTK31-gtk3 ];

  cmakeFlags = [ "-DUSE_HAMLIB=ON" ]
    ++ lib.optional enableDigitalLab "-DENABLE_DIGITAL_LAB=ON";

  meta = with lib; {
    homepage = "https://cubicsdr.com";
    description = "Software Defined Radio application";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ lasandell ];
    platforms = platforms.linux;
  };
}
