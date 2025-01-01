{ lib, stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  pname = "opentracing-cpp";
  version = "1.6.0";
  src = fetchFromGitHub {
    owner = "opentracing";
    repo = "opentracing-cpp";
    rev = "v${version}";
    sha256 = "09wdwbz8gbjgyqi764cyb6aw72wng6hwk44xpl432gl7whrrysvi";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "C++ implementation of the OpenTracing API";
    homepage = "https://opentracing.io";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rob ];
  };

}
