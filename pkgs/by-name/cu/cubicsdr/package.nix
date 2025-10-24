{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  fftw,
  hamlib,
  libpulseaudio,
  libGL,
  libX11,
  liquid-dsp,
  pkg-config,
  soapysdr-with-plugins,
  wxGTK32,
  enableDigitalLab ? false,
}:

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

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    fftw
    hamlib
    liquid-dsp
    soapysdr-with-plugins
    wxGTK32
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libpulseaudio
    libGL
    libX11
  ];

  cmakeFlags = [ "-DUSE_HAMLIB=ON" ] ++ lib.optional enableDigitalLab "-DENABLE_DIGITAL_LAB=ON";

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required (VERSION 2.8)" "cmake_minimum_required (VERSION 3.10)"
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool -change libliquid.dylib ${lib.getLib liquid-dsp}/lib/libliquid.dylib ''${out}/bin/CubicSDR
  '';

  meta = with lib; {
    homepage = "https://cubicsdr.com";
    description = "Software Defined Radio application";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ lasandell ];
    platforms = platforms.unix;
    mainProgram = "CubicSDR";
  };
}
