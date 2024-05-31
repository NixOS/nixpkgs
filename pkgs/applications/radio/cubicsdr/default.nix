{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, fftw, hamlib, libpulseaudio, libGL, libX11,
  liquid-dsp, pkg-config, soapysdr-with-plugins, wxGTK32, enableDigitalLab ? false,
  Cocoa, WebKit }:

stdenv.mkDerivation rec {
  pname = "cubicsdr";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "cjcliffe";
    repo = "CubicSDR";
    rev = version;
    sha256 = "0cyv1vk97x4i3h3hhh7dx8mv6d1ad0fypdbx5fl26bz661sr8j2n";
  };

  patches = [
    # Fix for liquid-dsp v1.50
    (fetchpatch {
      url = "https://github.com/cjcliffe/CubicSDR/commit/0e3a785bd2af56d18ff06b56579197b3e89b34ab.patch";
      sha256 = "sha256-mPfNZcV3FnEtGVX4sCMSs+Qc3VeSBIRkpCyx24TKkcU=";
    })
  ];

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ fftw hamlib liquid-dsp soapysdr-with-plugins wxGTK32 ]
    ++ lib.optionals stdenv.isLinux [ libpulseaudio libGL libX11 ]
    ++ lib.optionals stdenv.isDarwin [ Cocoa WebKit ];

  cmakeFlags = [ "-DUSE_HAMLIB=ON" ]
    ++ lib.optional enableDigitalLab "-DENABLE_DIGITAL_LAB=ON";

  meta = with lib; {
    homepage = "https://cubicsdr.com";
    description = "Software Defined Radio application";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ lasandell ];
    platforms = platforms.unix;
    mainProgram = "CubicSDR";
  };
}
