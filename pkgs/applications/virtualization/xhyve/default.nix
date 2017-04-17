{ stdenv, lib, fetchurl, Hypervisor, vmnet, xpc, libobjc }:

stdenv.mkDerivation rec {
  name    = "xhyve-${version}";
  version = "1f1dbe305";

  src = fetchurl {
    url    = "https://github.com/mist64/xhyve/archive/1f1dbe3059904f885e4ab2b3328f4bb350ea5c37.tar.gz";
    sha256 = "0hfix8yr90szlv2yyqb2rlq5qsrxyam8kg52sly0adja0cpwfjvx";
  };

  buildInputs = [ Hypervisor vmnet xpc libobjc ];

  # Don't use git to determine version
  prePatch = ''
    substituteInPlace Makefile \
      --replace 'shell git describe --abbrev=6 --dirty --always --tags' "$version"
  '';


  makeFlags = [ "CFLAGS+=-Wno-shift-sign-overflow" ''CFLAGS+=-DVERSION=\"${version}\"'' ];

  installPhase = ''
    mkdir -p $out/bin
    cp build/xhyve $out/bin
  '';

  meta = {
    description = "Lightweight Virtualization on OS X Based on bhyve";
    homepage = "https://github.com/mist64/xhyve";
    maintainers = [ lib.maintainers.lnl7 ];
    platforms = lib.platforms.darwin;
  };
}
