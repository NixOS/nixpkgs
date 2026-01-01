{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  krb5,
  liburcu,
  libtirpc,
  libnsl,
<<<<<<< HEAD
  prometheus-cpp-lite,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

stdenv.mkDerivation rec {
  pname = "ntirpc";
<<<<<<< HEAD
  version = "7.2";
=======
  version = "6.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "nfs-ganesha";
    repo = "ntirpc";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-4E6wDAwinCNn7arRgBulg7e0x9S/steh+mjwNY4X3Vc=";
=======
    sha256 = "sha256-e4eF09xwX2Qf/y9YfOGy7p6yhDFnKGI5cnrQy3o8c98=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    prometheus-cpp-lite
  ];

  cmakeFlags = [
    "-DUSE_MONITORING=ON"
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  postInstall = ''
    mkdir -p $out/etc

    # Library needs a netconfig to run.
    # Steal the file from libtirpc
    cp ${libtirpc}/etc/netconfig $out/etc/
  '';

<<<<<<< HEAD
  meta = {
    description = "Transport-independent RPC (TI-RPC)";
    homepage = "https://github.com/nfs-ganesha/ntirpc";
    maintainers = [ lib.maintainers.markuskowa ];
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd3;
=======
  meta = with lib; {
    description = "Transport-independent RPC (TI-RPC)";
    homepage = "https://github.com/nfs-ganesha/ntirpc";
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
    license = licenses.bsd3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
