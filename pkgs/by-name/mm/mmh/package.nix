{
  lib,
  stdenv,
  fetchurl,
  ncurses,
  autoreconfHook,
  flex,
}:
let
  rev = "7e93dee44df1a7e8f551a2e408a600b2e90a0974";
in
stdenv.mkDerivation {
  pname = "mmh";
  version = "unstable-2023-09-24";

  src = fetchurl {
    url = "http://git.marmaro.de/?p=mmh;a=snapshot;h=${rev};sf=tgz";
    name = "mmh-${rev}.tgz";
    hash = "sha256-t2Qnwtkli+/MDk6uaikS2SIP9LucK64os8kGcn2ytRU=";
  };

  postPatch = ''
    substituteInPlace sbr/Makefile.in \
      --replace-fail "ar " "${stdenv.cc.targetPrefix}ar "
  '';

  buildInputs = [ ncurses ];
  nativeBuildInputs = [
    autoreconfHook
    flex
  ];

  # mhl.c:1031:58: error: pointer type mismatch in conditional expression []
  #  1031 |                 putstr((c1->c_flags & RTRIM) ? rtrim(cp) : cp);
  NIX_CFLAGS_COMPILE = [ " -Wno-error=incompatible-pointer-types" ];

  enableParallelBuilding = true;

  meta = {
    description = "Set of electronic mail handling programs";
    homepage = "http://marmaro.de/prog/mmh";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with lib.maintainers; [ kaction ];
  };
}
