{ stdenv, fetchurl, iasl, python }:

stdenv.mkDerivation rec {
  pname = "seabios";
  version = "1.12.1";

  src = fetchurl {
    url = "https://review.coreboot.org/cgit/seabios.git/snapshot/seabios-rel-${version}.tar.gz";
    sha256 = "15kdrn0w7wrdrjnjx0g8pw7n00p1ss1r1gcdnq62dvcrzczvpy5m";
  };

  buildInputs = [ iasl python ];

  hardeningDisable = [ "pic" "stackprotector" "fortify" ];

  configurePhase = ''
    # build SeaBIOS for CSM
    cat > .config << EOF
    CONFIG_CSM=y
    CONFIG_QEMU_HARDWARE=y
    CONFIG_PERMIT_UNALIGNED_PCIROM=y
    EOF

    make olddefconfig
  '';

  installPhase = ''
    mkdir $out
    cp out/Csm16.bin $out/Csm16.bin
  '';

  meta = with stdenv.lib; {
    description = "Open source implementation of a 16bit X86 BIOS";
    longDescription = ''
      SeaBIOS is an open source implementation of a 16bit X86 BIOS.
      It can run in an emulator or it can run natively on X86 hardware with the use of coreboot.
      SeaBIOS is the default BIOS for QEMU and KVM.
    '';
    homepage = "https://www.seabios.org";
    license = licenses.lgpl3;
    maintainers = [ maintainers.tstrobel ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}

