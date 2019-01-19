{ stdenv, fetchFromGitHub, cmake, python }:

stdenv.mkDerivation rec {

  pname = "energyplus";
  version = "9.0.1";

  src = fetchFromGitHub {
    owner = "NREL";
    repo = "EnergyPlus";
    rev = "v${version}";
    sha256 = "1578iv879dsyjssq0slfmyk1a3dpsg8xswrskwin7n6l0iasy1hc";
  };

  buildInputs = [ cmake python ];

  # cmakeFlags = [
  #   "-DBUILD_FORTRAN=ON"
  # ];

  meta = with stdenv.lib; {
    description = "A whole building energy simulation program";
    homepage = https://energyplus.net/;
    maintainers = with maintainers; [ jluttine ];
  };

}
