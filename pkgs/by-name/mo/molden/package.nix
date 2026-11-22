{
  lib,
  stdenv,
  fetchurl,
  which,
  gfortran,
  libGLU,
  libxmu,
  libx11,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "7.3";
  pname = "molden";

  src = fetchurl {
    url = "https://ftp.science.ru.nl/Molden//molden${finalAttrs.version}.tar.gz";
    sha256 = "sha256-hw9PpmNSKXkbsJu70H9RRWsskBAdc1ZNxH7XdpuMB6E=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    which
    gfortran
  ];

  buildInputs = [
    libGLU
    libx11
    libxmu
  ];

  patches = [
    # realpath() needs a PATH_MAX sized buffer, otherwise _FORTIFY_SOURCE aborts
    ./realpath-buffers.patch
  ];

  # fix build with GCC 14+
  env.NIX_CFLAGS_COMPILE = "-Wno-implicit-function-declaration -Wno-implicit-int -Wno-return-mismatch -std=gnu17";

  postPatch = ''
    substituteInPlace ./makefile --replace-fail '-L/usr/X11R6/lib'  "" \
                                 --replace-fail '-I/usr/X11R6/include' "" \
                                 --replace-fail '/usr/local/' $out/ \
                                 --replace-fail 'sudo' "" \
                                 --replace-fail '$(MAKE) -C src/surf depend' "" \
                                 --replace-fail 'FFLAGS += -g' 'FFLAGS += -fallow-argument-mismatch -g'

    substituteInPlace src/ambfor/makefile --replace-fail 'FFLAGS =' 'FFLAGS = -fallow-argument-mismatch'
    substituteInPlace docker/makefile --replace-fail 'FFLAGS = -g' 'FFLAGS = -fallow-argument-mismatch -g'

    # open() with O_CREAT requires a mode argument (fails with _FORTIFY_SOURCE)
    substituteInPlace src/xwin.c --replace-fail 'open("log",O_CREAT|O_WRONLY)' 'open("log",O_CREAT|O_WRONLY,0644)'

    sed -i '/^# DO NOT DELETE THIS LINE/q;' src/surf/Makefile
  '';

  preInstall = ''
    mkdir -p $out/bin
  '';

  enableParallelBuilding = false;

  meta = {
    description = "Display and manipulate molecular structures";
    homepage = "http://www3.cmbi.umcn.nl/molden/";
    license = lib.licenses.mkLicense {
      shortName = "molden";
      fullName = "Free for academic/non-profit use";
      url = "http://www3.cmbi.umcn.nl/molden/CopyRight.html";
      free = false;
    };
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ markuskowa ];
  };
})
