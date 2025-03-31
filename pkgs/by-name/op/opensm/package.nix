{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
  bison,
  flex,
  rdma-core,
}:

stdenv.mkDerivation rec {
  pname = "opensm";
  version = "3.3.24";

  src = fetchFromGitHub {
    owner = "linux-rdma";
    repo = "opensm";
    rev = version;
    sha256 = "sha256-/bqo5r9pVt7vg29xaRRO/9k21AMlmoe2327Ot5gVIwc=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    bison
    flex
  ];

  buildInputs = [ rdma-core ];

  preConfigure = ''
    patchShebangs ./autogen.sh
    ./autogen.sh
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Infiniband subnet manager";
    homepage = "https://www.openfabrics.org/";
    license = licenses.gpl2Only; # dual licensed as 2-clause BSD
    maintainers = [ maintainers.aij ];
    platforms = [ "x86_64-linux" ];
  };
}
