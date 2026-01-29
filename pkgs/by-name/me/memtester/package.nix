{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "memtester";
  version = "4.7.1";

  preConfigure = ''
    echo "$CC" > conf-cc
    echo "$CC" > conf-ld
  '';

  src = fetchurl {
    url = "http://pyropus.ca/software/memtester/old-versions/memtester-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-5CfeZj970i0evuivElBqhSwBC9T8vKHg5rApctKYtbs=";
  };

  installFlags = [ "INSTALLPATH=$(out)" ];

  meta = {
    description = "Userspace utility for testing the memory subsystem for faults";
    homepage = "http://pyropus.ca/software/memtester/";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.dezgeg ];
    platforms = lib.platforms.unix;
    mainProgram = "memtester";
  };
})
