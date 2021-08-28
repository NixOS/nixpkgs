{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, fftw, hamlib, libpulseaudio, libGL, libX11, liquid-dsp,
  pkg-config, soapysdr-with-plugins, wxGTK31-gtk3, enableDigitalLab ? false }:

stdenv.mkDerivation rec {
  pname = "cubicsdr";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "cjcliffe";
    repo = "CubicSDR";
    rev = version;
    sha256 = "1ihbn18bzdcdvwpa4hnb55ns38bj4b8xy53hkmra809f9qpbcjhn";
  };

  # Allow cubicsdr 0.2.5 to build with wxGTK 3.1.3
  # these come from cubicsdr's master branch, subsequent releases may include them
  patches = [
    (fetchpatch {
      url = "https://github.com/cjcliffe/CubicSDR/commit/65a160fa356ce9665dfe05c6bfc6754535e16743.patch";
      sha256 = "0vbr5x9fnm09bws5crqcm6kkhr1bg5r0bc1pxnwwjyc6jpvqi6ad";
    })
    (fetchpatch {
      url = "https://github.com/cjcliffe/CubicSDR/commit/f449a65457e35bf8260d0b16b8a47b6bc0ea2c7e.patch";
      sha256 = "1zjvjmhm8ybi6i9pq7by3fj3mvx37dy7gj4gk23d79yrnl9mk25p";
    })
    (fetchpatch {
      url = "https://github.com/cjcliffe/CubicSDR/commit/0540d08c2dea79b668b32b1a6d58f235d65ce9d2.patch";
      sha256 = "07l7b82f779sbcj0jza0mg463ac1153bs9hn6ai388j7dm3lvasn";
    })
  ];

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

