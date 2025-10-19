{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  krb5,
  liburcu,
  libtirpc,
  libnsl,
}:

stdenv.mkDerivation rec {
  pname = "ntirpc";
  version = "6.3";

  src = fetchFromGitHub {
    owner = "nfs-ganesha";
    repo = "ntirpc";
    rev = "v${version}";
    sha256 = "sha256-e4eF09xwX2Qf/y9YfOGy7p6yhDFnKGI5cnrQy3o8c98=";
  };

  outputs = [
    "out"
    "dev"
  ];
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      "cmake_minimum_required(VERSION 2.6.3)" \
      "cmake_minimum_required(VERSION 3.10)"

    substituteInPlace ntirpc/netconfig.h --replace-fail \
      "/etc/netconfig" "$out/etc/netconfig"
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    krb5
    liburcu
    libnsl
  ];

  postInstall = ''
    mkdir -p $out/etc

    # Library needs a netconfig to run.
    # Steal the file from libtirpc
    cp ${libtirpc}/etc/netconfig $out/etc/
  '';

  meta = with lib; {
    description = "Transport-independent RPC (TI-RPC)";
    homepage = "https://github.com/nfs-ganesha/ntirpc";
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
    license = licenses.bsd3;
  };
}
