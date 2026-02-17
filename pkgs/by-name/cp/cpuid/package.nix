{
  lib,
  stdenv,
  fetchurl,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cpuid";
  version = "20250513";

  src = fetchurl {
    url = "http://etallen.com/cpuid/cpuid-${finalAttrs.version}.src.tar.gz";
    sha256 = "sha256-b0dKIrWEhIjkVLAaMduA65WNVWdLUzlTP8DmrreTYms=";
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

  meta = {
    description = "Linux tool to dump x86 CPUID information about the CPU";
    longDescription = ''
      cpuid dumps detailed information about the CPU(s) gathered from the CPUID
      instruction, and also determines the exact model of CPU(s). It supports
      Intel, AMD, VIA, Hygon, and Zhaoxin CPUs, as well as older Transmeta,
      Cyrix, UMC, NexGen, Rise, and SiS CPUs.
    '';
    homepage = "http://etallen.com/cpuid.html";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ blitz ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
})
