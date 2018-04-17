{ stdenv, fetchFromGitHub
, pkgconfig, SDL2, SDL, SDL2_ttf, openssl, spice-protocol, fontconfig
, libX11, freefont_ttf
}:

stdenv.mkDerivation rec {
  name = "looking-glass-client-${version}";
  version = "a10";

  src = fetchFromGitHub {
    owner = "gnif";
    repo = "LookingGlass";
    rev = version;
    sha256 = "10jxnkrvskjzkg86iz3hnb5v91ykzx6pvcnpy1v4436g5f2d62wn";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    SDL SDL2 SDL2_ttf openssl spice-protocol fontconfig
    libX11 freefont_ttf
  ];

  enableParallelBuilding = true;

  sourceRoot = "source/client";

  installPhase = ''
    mkdir -p $out
    mv bin $out/
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
    homepage = https://looking-glass.hostfission.com/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.pneumaticat ];
    platforms = [ "x86_64-linux" ];
  };
}
