{ lib, stdenv, fetchurl, autoreconfHook, net-snmp }:

stdenv.mkDerivation rec {
  pname = "ifstat-legacy";
  version = "1.1";

  src = fetchurl {
    url = "http://gael.roualland.free.fr/ifstat/ifstat-${version}.tar.gz";
    sha256 = "01zmv6vk5kh5xmd563xws8a1qnxjb6b6kv59yzz9r3rrghxhd6c5";
  };

  buildInputs = lib.optional stdenv.hostPlatform.isLinux net-snmp;

  nativeBuildInputs = [ autoreconfHook ];

  enableParallelBuilding = true;

  postInstall = ''
    mv $out/bin/ifstat $out/bin/ifstat-legacy
    mv $out/share/man/man1/ifstat.1 $out/share/man/man1/ifstat-legacy.1
  '';

  meta = with lib; {
    description = "Report network interfaces bandwith just like vmstat/iostat do for other system counters - legacy version";
    homepage    = "http://gael.roualland.free.fr/ifstat/";
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = platforms.unix;
    license     = licenses.gpl2Plus;
    mainProgram = "ifstat-legacy";
  };
}
