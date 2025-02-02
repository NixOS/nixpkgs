{
  lib,
  stdenv,
  fetchurl,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "cpuid";
  version = "20241023";

  src = fetchurl {
    url = "http://etallen.com/cpuid/${pname}-${version}.src.tar.gz";
    sha256 = "sha256-/HdDWo1dKzVRcTMB6M24PmKjz+3IQTKw7JsbteUkT9w=";
  };

  # For pod2man during the build process.
  nativeBuildInputs = [ perl ];

  # As runtime dependency for cpuinfo2cpuid.
  buildInputs = [ perl ];

  # The Makefile hardcodes $(BUILDROOT)/usr as installation
  # destination. Just nuke all mentions of /usr to get the right
  # installation location.
  patchPhase = ''
    sed -i -e 's,/usr/,/,' Makefile
  '';

  installPhase = ''
    make install BUILDROOT=$out

    if [ ! -x $out/bin/cpuid ]; then
      echo Failed to properly patch Makefile.
      exit 1
    fi
  '';

  meta = with lib; {
    description = "Linux tool to dump x86 CPUID information about the CPU";
    longDescription = ''
      cpuid dumps detailed information about the CPU(s) gathered from the CPUID
      instruction, and also determines the exact model of CPU(s). It supports
      Intel, AMD, VIA, Hygon, and Zhaoxin CPUs, as well as older Transmeta,
      Cyrix, UMC, NexGen, Rise, and SiS CPUs.
    '';
    homepage = "http://etallen.com/cpuid.html";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ blitz ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
