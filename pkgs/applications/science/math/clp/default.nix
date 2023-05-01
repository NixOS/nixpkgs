{ lib, stdenv, fetchFromGitHub, pkg-config, coin-utils, zlib, osi }:

stdenv.mkDerivation rec {
  version = "1.17.7";
  pname = "clp";
  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "Clp";
    rev = "releases/${version}";
    hash = "sha256-CfAK/UbGaWvyk2ZxKEgziVruzZfz7WMJVi/YvdR/UNA=";
  };

  nativeBuildInputs = [ pkg-config ];

  propagatedBuildInputs = [ zlib coin-utils osi ];

  doCheck = true;

  meta = with lib; {
    license = licenses.epl20;
    homepage = "https://github.com/coin-or/Clp";
    description = "An open-source linear programming solver written in C++";
    platforms = platforms.darwin ++ [ "x86_64-linux" ];
    maintainers = [ maintainers.vbgl ];
  };
}
