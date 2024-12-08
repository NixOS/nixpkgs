{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  civetweb,
  curl,
  gbenchmark,
  gtest,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "prometheus-cpp";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "jupp0r";
    repo = "prometheus-cpp";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-qx6oBxd0YrUyFq+7ArnKBqOwrl5X8RS9nErhRDUJ7+8=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    curl
    gbenchmark
    gtest
    zlib
  ];
  propagatedBuildInputs = [ civetweb ];
  strictDeps = true;

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DUSE_THIRDPARTY_LIBRARIES=OFF"
  ];

  outputs = [
    "out"
    "dev"
  ];

  postInstall = ''
    mkdir -p $dev/lib/pkgconfig
    substituteAll ${./prometheus-cpp.pc.in} $dev/lib/pkgconfig/prometheus-cpp.pc
  '';

  meta = {
    description = "Prometheus Client Library for Modern C++";
    homepage = "https://github.com/jupp0r/prometheus-cpp";
    license = [ lib.licenses.mit ];
  };
})
