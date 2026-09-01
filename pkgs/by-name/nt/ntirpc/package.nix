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
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ntirpc";
  version = "15.2"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "nfs-ganesha";
    repo = "ntirpc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YlWt2S2dggLATIBYb1hr281aeZ3AOWMzMt45tYOk6J8=";
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
    openssl
  ];

  cmakeFlags = [
    "-DUSE_MONITORING=ON"
    "-DUSE_RPC_RDMA=ON"
    "-DUSE_TLS=ON"
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
