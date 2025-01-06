{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "cista";
  version = "0.15";

  src = fetchFromGitHub {
    owner = "felixguendling";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+DcxnckoXVSc+gXt21fxKkx4J1khLsQPuxYH9CBRrfE=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DCISTA_INSTALL=ON" ];

  meta = {
    homepage = "https://cista.rocks";
    description = "Simple, high-performance, zero-copy C++ serialization & reflection library";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sigmanificient ];
    platforms = lib.platforms.all;
  };
}
