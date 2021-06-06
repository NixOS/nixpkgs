{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, SDL2, SDL2_ttf, spice-protocol
, fontconfig, libX11, freefont_ttf, nettle, libpthreadstubs, libXau, libXdmcp
, libXi, libXext, wayland, wayland-protocols, libffi, libGLU, libXScrnSaver
, expat, libbfd
}:

stdenv.mkDerivation rec {
  pname = "looking-glass-client";
  version = "B3";

  src = fetchFromGitHub {
    owner = "gnif";
    repo = "LookingGlass";
    rev = version;
    sha256 = "1vmabjzn85p0brdian9lbpjq39agzn8k0limn8zjm713lh3n3c0f";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    SDL2 SDL2_ttf spice-protocol fontconfig libX11 freefont_ttf nettle
    libpthreadstubs libXau libXdmcp libXi libXext wayland wayland-protocols
    libffi libGLU libXScrnSaver expat libbfd
  ];

  patches = [
    # error: ‘h’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
    # Fixed upstream in master in 8771103abbfd04da9787dea760405364af0d82de, but not in B3.
    # Including our own patch here since upstream commit patch doesnt apply cleanly on B3
    ./0001-client-all-fix-more-maybe-uninitialized-when-O3-is-i.patch
  ];
  patchFlags = "-p2";

  sourceRoot = "source/client";
  NIX_CFLAGS_COMPILE = "-mavx"; # Fix some sort of AVX compiler problem.

  meta = with lib; {
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
