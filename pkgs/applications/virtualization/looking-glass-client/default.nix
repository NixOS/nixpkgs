{ stdenv, fetchFromGitHub, fetchpatch
, cmake, pkgconfig, SDL2, SDL, SDL2_ttf, openssl, spice-protocol, fontconfig
, libX11, freefont_ttf, nettle, libconfig
}:

stdenv.mkDerivation rec {
  name = "looking-glass-client-${version}";
  version = "a12";

  src = fetchFromGitHub {
    owner = "gnif";
    repo = "LookingGlass";
    rev = version;
    sha256 = "0r6bvl9q94039r6ff4f2bg8si95axx9w8bf1h1qr5730d2kv5yxq";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    SDL SDL2 SDL2_ttf openssl spice-protocol fontconfig
    libX11 freefont_ttf nettle libconfig cmake
  ];

  patches = [
    # Fix obsolete spice header usage. Remove with the next release. See https://github.com/gnif/LookingGlass/pull/126
    (fetchpatch {
      url = "https://github.com/gnif/LookingGlass/commit/2567447b24b28458ba0f09c766a643ad8d753255.patch";
      sha256 = "04j2h75rpxd71szry15f31r6s0kgk96i8q9khdv9q3i2fvkf242n";
      stripLen = 1;
    })
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
    homepage = https://looking-glass.hostfission.com/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.pneumaticat ];
    platforms = [ "x86_64-linux" ];
  };
}
