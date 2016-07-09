{ stdenv, fetchurl, iasl, python }:

stdenv.mkDerivation rec {

  name = "seabios-${version}";
  version = "1.9.2";

  src = fetchurl {
    url = "http://code.coreboot.org/p/seabios/downloads/get/${name}.tar.gz";
    sha256 = "1rdvbqb374jimxbkk9yvk9rnzhkn0w0sbvi1l3gnz6ah1sdla7gh";
  };

  buildInputs = [ iasl python ];

  hardeningDisable = [ "pic" "stackprotector" ];

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
    homepage = http://www.seabios.org;
    license = licenses.lgpl3;
    maintainers = [ maintainers.tstrobel ];
    platforms = platforms.linux;
  };
}

