{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  name = "gvisor-containerd-shim-${version}";
  version = "2019-10-09";

  src = fetchFromGitHub {
    owner  = "google";
    repo   = "gvisor-containerd-shim";
    rev    = "f299b553afdd8455a0057862004061ea12e660f5";
    sha256 = "077bhrmjrpcxv1z020yxhx2c4asn66j21gxlpa6hz0av3lfck9lm";
  };

  modSha256 = "1jdhgbrn59ahnabwnig99i21f6kimmqx9f3dg10ffwfs3dx0gzlg";

  buildPhase = ''
    make
  '';

  doCheck = true;
  checkPhase = ''
    make test
  '';

  installPhase = ''
    make install DESTDIR="$out"
  '';

  meta = with lib; {
    description = "containerd shim for gVisor";
    homepage    = https://github.com/google/gvisor-containerd-shim;
    license     = licenses.asl20;
    maintainers = with maintainers; [ andrew-d ];
    platforms   = [ "x86_64-linux" ];
  };
}
