{lib, stdenv, fetchurl, pkg-config, which, libao}:

stdenv.mkDerivation {
  name = "uade-2.13";
  src = fetchurl {
    url = "http://zakalwe.fi/uade/uade2/uade-2.13.tar.bz2";
    sha256 = "04nn5li7xy4g5ysyjjngmv5d3ibxppkbb86m10vrvadzxdd4w69v";
  };

  buildInputs = [ pkg-config which libao ];

  preBuild = ''
    # Force not using -Wformat to become an error
    sed -i -e "s|-Wno-format|-Wno-format -Wno-error=format-security|g" src/Makefile

    # Fix warnings are errors problem related to the missing return types of freopen and fscanf
    sed -i -e 's|freopen ("cpuemu.c|(void)!freopen ("cpuemu.c|' \
      -e 's|fscanf (file, "Total|(void)!fscanf (file, "Total|' src/gencpu.c
  '';

  meta = with lib; {
    description = "UADE plays old Amiga tunes through UAE emulation and cloned m68k-assembler Eagleplayer API";
    homepage = "http://zakalwe.fi/uade/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ sander ];
    platforms = with platforms; linux;
  };
}
