{ stdenv, fetchFromGitHub, cmake, pkgconfig, SDL2, SDL2_ttf, spice-protocol
, fontconfig, libX11, freefont_ttf, nettle, libpthreadstubs, libXau, libXdmcp
, libXi, libXext, wayland, libffi, libGLU, expat, libbfd
}:

stdenv.mkDerivation rec {
  pname = "looking-glass-client";
  version = "B2";

  src = fetchFromGitHub {
    owner = "gnif";
    repo = "LookingGlass";
    rev = version;
    sha256 = "100b5kzh8gr81kzw5fdqz2jsms25hv3815d31vy3qd6lrlm5gs3d";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    SDL2 SDL2_ttf spice-protocol fontconfig libX11 freefont_ttf nettle
    libpthreadstubs libXau libXdmcp libXi libXext wayland libffi libGLU expat
    libbfd
  ];

  sourceRoot = "source/client";
  NIX_CFLAGS_COMPILE = "-mavx"; # Fix some sort of AVX compiler problem.

  meta = with stdenv.lib; {
    description = "A KVM Frame Relay (KVMFR) implementation";
    longDescription = ''
      Looking Glass is an open source application that allows the use of a KVM
      (Kernel-based Virtual Machine) configured for VGA PCI Pass-through
      without an attached physical monitor, keyboard or mouse. This is the final
      step required to move away from dual booting with other operating systems
      for legacy programs that require high performance graphics.
    '';
    homepage = "https://looking-glass.io/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ alexbakker ];
    platforms = [ "x86_64-linux" ];
  };
}
