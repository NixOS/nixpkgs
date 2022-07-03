{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "gvisor-containerd-shim";
  version = "unstable-2019-10-09";

  src = fetchFromGitHub {
    owner  = "google";
    repo   = "gvisor-containerd-shim";
    rev    = "f299b553afdd8455a0057862004061ea12e660f5";
    sha256 = "077bhrmjrpcxv1z020yxhx2c4asn66j21gxlpa6hz0av3lfck9lm";
  };

  vendorSha256 = "11jai5jl024k7wbhz4a3zzdbvl0si07jwgwmyr8bn4i0nqx8ig2k";

  buildPhase = ''
    make
  '';

  checkPhase = ''
    make test
  '';

  installPhase = ''
    make install DESTDIR="$out"
  '';

  meta = with lib; {
    description = "containerd shim for gVisor";
    homepage    = "https://github.com/google/gvisor-containerd-shim";
    license     = licenses.asl20;
    maintainers = with maintainers; [ andrew-d ];
    platforms   = [ "x86_64-linux" ];
  };
}
