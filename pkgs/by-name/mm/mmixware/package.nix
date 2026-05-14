{
  lib,
  stdenv,
  fetchFromGitLab,
  texliveMedium,
}:

stdenv.mkDerivation {
  pname = "mmixware";
  version = "1.0-unstable-2025-06-30";

  src = fetchFromGitLab {
    domain = "gitlab.lrz.de";
    owner = "mmix";
    repo = "mmixware";
    rev = "9205420225f4227462e37e298ee482a5c37e9c23";
    sha256 = "sha256-u6eGc+R9xsr4sMslj1ytgSUY54qSOONEc3QtbY2r+8A=";
  };

  hardeningDisable = [ "format" ];

  postPatch = ''
    substituteInPlace Makefile --replace 'rm abstime.h' ""
  '';

  env.NIX_CFLAGS_COMPILE = toString [
    # Workaround build failure on -fno-common toolchains:
    #   ld: mmix-config.o:(.bss+0x600): multiple definition of `buffer'; /build/ccDuGrwH.o:(.bss+0x20): first defined here
    "-fcommon"
    # Workaround to build with GCC 15
    "-std=gnu17"
  ];

  nativeBuildInputs = [ texliveMedium ];
  enableParallelBuilding = true;

  makeFlags = [
    "all"
    "doc"
    "CFLAGS=-O2"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/doc
    cp *.ps $out/share/doc
    install -Dm755 mmixal -t $out/bin
    install -Dm755 mmix -t $out/bin
    install -Dm755 mmotype -t $out/bin
    install -Dm755 mmmix -t $out/bin
    runHook postInstall
  '';

  meta = {
    description = "MMIX simulator and assembler";
    homepage = "https://www-cs-faculty.stanford.edu/~knuth/mmix-news.html";
    maintainers = with lib.maintainers; [ siraben ];
    platforms = lib.platforms.unix;
    license = lib.licenses.publicDomain;
  };
}
