{ stdenv, fetchFromGitHub, fetchpatch
, cmake, pkgconfig, SDL2, SDL, SDL2_ttf, openssl, spice-protocol, fontconfig
, libX11, freefont_ttf, nettle, libconfig, wayland, libpthreadstubs, libXdmcp
, libXfixes, libbfd
}:

stdenv.mkDerivation rec {
  pname = "looking-glass-client";
  version = "B1";

  src = fetchFromGitHub {
    owner = "gnif";
    repo = "LookingGlass";
    rev = version;
    sha256 = "0vykv7yjz4fima9d82m83acd8ab72nq4wyzyfs1c499i27wz91ia";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    SDL SDL2 SDL2_ttf openssl spice-protocol fontconfig
    libX11 freefont_ttf nettle libconfig wayland libpthreadstubs
    libXdmcp libXfixes libbfd cmake
  ];

  enableParallelBuilding = true;

  sourceRoot = "source/client";

  installPhase = ''
    mkdir -p $out/bin
    mv looking-glass-client $out/bin
  '';

  meta = with stdenv.lib; {
    description = "A KVM Frame Relay (KVMFR) implementation";
    longDescription = ''
      Looking Glass is an open source application that allows the use of a KVM
      (Kernel-based Virtual Machine) configured for VGA PCI Pass-through
      without an attached physical monitor, keyboard or mouse. This is the final
      step required to move away from dual booting with other operating systems
      for legacy programs that require high performance graphics.
    '';
    homepage = "https://looking-glass.hostfission.com/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.alexbakker ];
    platforms = [ "x86_64-linux" ];
  };
}
