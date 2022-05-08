{ lib, stdenv, fetchgit, acpica-tools, python3
, csm ? true # whether to build SeaBIOS as an UEFI Compatibility Support Module
, tsc ? true # whether to enable the TSC timer
}:

let
  toYesNo = b: if b then "y" else "n";
in

stdenv.mkDerivation rec {

  pname = "seabios";
  version = "1.16.0";

  src = fetchgit {
    url = "https://git.seabios.org/seabios.git";
    rev = "rel-${version}";
    sha256 = "0acal1rr7sya86wlhw2mgimabwhjnr0y1pl5zxwb79j8k1w1r8sh";
  };

  nativeBuildInputs = [ python3 ];

  buildInputs = [ acpica-tools ];

  strictDeps = true;

  hardeningDisable = [ "pic" "stackprotector" "fortify" ];

  configurePhase = ''
    cat > .config << EOF
    CONFIG_CSM=${toYesNo csm}
    CONFIG_TSC_TIMER=${toYesNo tsc}
    CONFIG_QEMU_HARDWARE=y
    EOF

    make olddefconfig
  '';

  installPhase = ''
    mkdir "$out"
    cp out/${if csm then "Csm16.bin" else "bios.bin"} "$out"/
  '';

  meta = with lib; {
    description = "Open source implementation of a 16bit X86 BIOS";
    longDescription = ''
      SeaBIOS is an open source implementation of a 16bit X86 BIOS.
      It can run in an emulator or it can run natively on X86 hardware with the use of coreboot.
      SeaBIOS is the default BIOS for QEMU and KVM.
    '';
    homepage = "http://www.seabios.org";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ tstrobel ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
