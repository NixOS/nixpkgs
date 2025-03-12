{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "pth";
  version = "2.0.7";

  src = fetchurl {
    url = "mirror://gnu/pth/pth-${version}.tar.gz";
    sha256 = "0ckjqw5kz5m30srqi87idj7xhpw6bpki43mj07bazjm2qmh3cdbj";
  };

  preConfigure =
    lib.optionalString stdenv.hostPlatform.isAarch32 ''
      configureFlagsArray=("CFLAGS=-DJB_SP=8 -DJB_PC=9")
    ''
    + lib.optionalString (stdenv.hostPlatform.libc == "glibc") ''
      configureFlagsArray+=("ac_cv_check_sjlj=ssjlj")
    '';

  # Fails parallel build due to missing dependency on autogenrated
  # 'pth_p.h' file:
  #     ./shtool scpp -o pth_p.h ...
  #     ./libtool --mode=compile --quiet gcc -c -I. -O2 -pipe pth_uctx.c
  #     pth_uctx.c:31:10: fatal error: pth_p.h: No such file
  enableParallelBuilding = false;

  meta = with lib; {
    description = "GNU Portable Threads library";
    mainProgram = "pth-config";
    homepage = "https://www.gnu.org/software/pth";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
  };
}
