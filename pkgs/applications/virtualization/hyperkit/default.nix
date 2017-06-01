{ stdenv, lib, fetchFromGitHub, Hypervisor, vmnet, xpc, libobjc }:

let
  rev = "3e31617ae866c93925e2b3bc5d8006b60985e920";
in
stdenv.mkDerivation rec {
  name    = "hyperkit-${version}";
  version = lib.strings.substring 0 7 rev;

  src = fetchFromGitHub {
    owner = "moby";
    repo = "hyperkit";
    inherit rev;
    sha256 = "1ndl6dj2qbwns2dcp43xhp5k9zcjmxl5y0rz46d8b3zwm7ixf2xr";
  };

  buildInputs = [ Hypervisor vmnet xpc libobjc ];

  # Don't use git to determine version
  prePatch = ''
    substituteInPlace Makefile \
      --replace 'shell git describe --abbrev=6 --dirty --always --tags' "$version" \
      --replace 'shell git rev-parse HEAD' "${rev}" \
      --replace 'PHONY: clean' 'PHONY:'
    cp ${./dtrace.h} src/include/xhyve/dtrace.h
  '';

  makeFlags = [ "CFLAGS+=-Wno-shift-sign-overflow" ''CFLAGS+=-DVERSION=\"${version}\"'' ''CFLAGS+=-DVERSION_SHA1=\"${rev}\"'' ];
  installPhase = ''
    mkdir -p $out/bin
    cp build/hyperkit $out/bin
  '';

  meta = {
    description = "Lightweight Virtualization on OS X Based on bhyve";
    homepage = "https://github.com/mist64/xhyve";
    maintainers = [ lib.maintainers.lnl7 ];
    platforms = lib.platforms.darwin;
  };
}
