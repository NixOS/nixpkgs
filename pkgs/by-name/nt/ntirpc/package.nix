{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  krb5,
  liburcu,
  libtirpc,
  libnsl,
  prometheus-cpp-lite,
  rdma-core,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ntirpc";
  version = "9.16";

  src = fetchFromGitHub {
    owner = "nfs-ganesha";
    repo = "ntirpc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZpjP1ugT9gN3TW7roBfJJBA6Y6FCkaOl31WRoRqPvTU=";
  };

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    ./pkg-config.patch
  ];

  postPatch = ''
    substituteInPlace ntirpc/netconfig.h --replace-fail \
      "/etc/netconfig" "$out/etc/netconfig"
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    krb5
    liburcu
    libnsl
    prometheus-cpp-lite
    rdma-core
  ];

  cmakeFlags = [
    "-DUSE_MONITORING=ON"
    "-DUSE_RPC_RDMA=ON"
  ];

  postInstall = ''
    mkdir -p $out/etc

    # Library needs a netconfig to run.
    # Steal the file from libtirpc
    cp ${libtirpc}/etc/netconfig $out/etc/
  '';

  meta = {
    description = "Transport-independent RPC (TI-RPC)";
    homepage = "https://github.com/nfs-ganesha/ntirpc";
    maintainers = [ lib.maintainers.markuskowa ];
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd3;
  };
})
