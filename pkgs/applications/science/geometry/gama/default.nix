{ stdenv, fetchurl, lib, expat, octave, libxml2, texinfo, zip }:
stdenv.mkDerivation rec {
  pname = "gama";
<<<<<<< HEAD
  version = "2.25";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-1j4fsPQEaftqmrdk6ZPWKSl7ywA/UPN8bdddGVlPxDQ=";
=======
  version = "2.24";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-AIRqBSO71c26TeQwxjfAGIy8YQddF4tq+ZnWztroyRM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ expat ];

  nativeBuildInputs = [ texinfo zip ];

  nativeCheckInputs = [ octave libxml2 ];
  doCheck = true;

  meta = with lib ; {
    description = "Tools for adjustment of geodetic networks";
    homepage = "https://www.gnu.org/software/gama/";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
  };
}
