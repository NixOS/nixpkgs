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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ntirpc";
  version = "7.2";

  src = fetchFromGitHub {
    owner = "nfs-ganesha";
    repo = "ntirpc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4E6wDAwinCNn7arRgBulg7e0x9S/steh+mjwNY4X3Vc=";
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
    prometheus-cpp-lite
  ];

  cmakeFlags = [
    "-DUSE_MONITORING=ON"
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
