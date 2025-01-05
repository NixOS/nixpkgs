{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  libpcap,
  withTcl ? true,
  tcl,
}:

stdenv.mkDerivation rec {
  pname = "hping";
  version = "2014-12-26";

  src = fetchFromGitHub {
    owner = "antirez";
    repo = pname;
    rev = "3547c7691742c6eaa31f8402e0ccbb81387c1b99"; # there are no tags/releases
    sha256 = "0y0n1ybij3yg9lfgzcwfmjz1sjg913zcqrv391xx83dm0j80sdpb";
  };
  patches = [
    # Pull patch pending upstream inclusion for -fno-common toolchain
    # support: https://github.com/antirez/hping/pull/64
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/antirez/hping/pull/64/commits/d057b9309aec3a5a53aaee1ac3451a8a5b71b4e8.patch";
      sha256 = "0bqr7kdlziijja588ipj8g5hv2109wq01c6x2qadbhjfnsps1b6l";
    })
  ];

  buildInputs = [ libpcap ] ++ lib.optional withTcl tcl;

  postPatch =
    ''
      substituteInPlace Makefile.in --replace "gcc" "$CC"
      substituteInPlace version.c --replace "RELEASE_DATE" "\"$version\""
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      sed -i -e 's|#include <net/bpf.h>|#include <pcap/bpf.h>|' \
        libpcap_stuff.c script.c
    ''
    + lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
      substituteInPlace configure --replace 'BYTEORDER=`./byteorder -m`' BYTEORDER=${
        {
          littleEndian = "__LITTLE_ENDIAN_BITFIELD";
          bigEndian = "__BIG_ENDIAN_BITFIELD";
        }
        .${stdenv.hostPlatform.parsed.cpu.significantByte.name}
      }
      substituteInPlace Makefile.in --replace './hping3 -v' ""
    '';

  configureFlags = [ (if withTcl then "TCLSH=${tcl}/bin/tclsh" else "--no-tcl") ];

  installPhase = ''
    install -Dm755 hping3 -t $out/sbin
    ln -s $out/sbin/hping3 $out/sbin/hping
    ln -s $out/sbin/hping3 $out/sbin/hping2
    install -Dm644 docs/hping3.8 -t $out/share/man/man8
    ln -s hping3.8.gz $out/share/man/man8/hping.8.gz
    ln -s hping3.8.gz $out/share/man/man8/hping2.8.gz
  '';

  meta = with lib; {
    description = "Command-line oriented TCP/IP packet assembler/analyzer";
    homepage = "http://www.hping.org/";
    license = licenses.gpl2Only;
    platforms = platforms.unix;
  };
}
