{ stdenv, lib, fetchFromGitHub
, Hypervisor, vmnet, SystemConfiguration
, xpc, libobjc, dtrace
}:

stdenv.mkDerivation rec {
  pname   = "hyperkit";
  version = "0.20190201"; # keep in sync with src.rev

  src = fetchFromGitHub {
    owner = "moby";
    repo = "hyperkit";
    rev = "64bbfbec66900334d91bb2ac32de60b5187cf6c9";
    sha256 = "0ql581m5s65l5a7v61bxhl8x1213dl9f0h82lwjsaii4h240bvkf";
  };

  buildInputs = [ Hypervisor vmnet SystemConfiguration xpc libobjc dtrace ];

  # 1. Don't use git to determine version
  # 2. Include dtrace probes
  prePatch = ''
    substituteInPlace Makefile \
      --replace 'shell git describe --abbrev=6 --dirty --always --tags' "v${version}" \
      --replace 'shell git rev-parse HEAD' "${src.rev}" \
      --replace 'PHONY: clean' 'PHONY:'
    make src/include/xhyve/dtrace.h
  '';

  makeFlags = [
    "CFLAGS+=-Wno-shift-sign-overflow"
    ''CFLAGS+=-DVERSION=\"v${version}\"''
    ''CFLAGS+=-DVERSION_SHA1=\"${src.rev}\"'' # required for vmnet
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp build/hyperkit $out/bin
  '';

  meta = with lib; {
    description = "A toolkit for embedding hypervisor capabilities in your application";
    homepage = https://github.com/moby/hyperkit;
    maintainers = with maintainers; [ nicknovitski ];
    platforms = platforms.darwin;
    license = licenses.bsd3;
  };
}
