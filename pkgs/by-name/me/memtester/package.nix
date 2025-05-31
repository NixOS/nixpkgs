{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "memtester";
  version = "4.7.1";

  preConfigure = ''
    echo "$CC" > conf-cc
    echo "$CC" > conf-ld
  '';

  src = fetchurl {
    url = "http://pyropus.ca/software/memtester/old-versions/memtester-${version}.tar.gz";
    sha256 = "sha256-5CfeZj970i0evuivElBqhSwBC9T8vKHg5rApctKYtbs=";
  };

  installFlags = [ "INSTALLPATH=$(out)" ];

  meta = with lib; {
    description = "Userspace utility for testing the memory subsystem for faults";
    homepage = "http://pyropus.ca/software/memtester/";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.unix;
    mainProgram = "memtester";
  };
}
