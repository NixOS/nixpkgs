{ stdenv, lib, fetchFromGitHub, Hypervisor, vmnet, xpc, libobjc, zlib }:

stdenv.mkDerivation rec {
  pname = "xhyve";
  version = "20191001";

  src = fetchFromGitHub {
    owner = "machyve";
    repo = "xhyve";
    rev = "1f46a3d0bbeb6c90883f302425844fcc3800a776";
    sha256 = "0mm9xa0v6n7xl2qypnppq5abdncd31vffiklrhcrlni5ymyh9ia5";
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
