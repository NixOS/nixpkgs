{ stdenv, lib, fetchurl, Hypervisor, vmnet, xpc, libobjc, zlib }:

stdenv.mkDerivation rec {
  pname = "xhyve";
  version = "20190124";

  src = fetchurl {
    url    = "https://github.com/machyve/xhyve/archive/1dd9a5165848c7ed56dafc41932c553ea56a12af.tar.gz";
    sha256 = "18zd74pd0azf43csbqb14srbyclfgx28dpgm8ygjmbcazbnipc1k";
  };

  buildInputs = [ Hypervisor vmnet xpc libobjc zlib ];

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
    description = "Lightweight Virtualization on macOS Based on bhyve";
    homepage = https://github.com/mist64/xhyve;
    maintainers = [ lib.maintainers.lnl7 ];
    platforms = lib.platforms.darwin;
  };
}
