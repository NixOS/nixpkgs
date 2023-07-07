{ lib, fetchFromGitHub, mkDerivation, qtbase, cmake, extra-cmake-modules, icecream, libcap_ng, lzo, zstd, libarchive, wrapQtAppsHook }:

mkDerivation rec {
  pname = "icemon";
  version = "3.3";

  src = fetchFromGitHub {
    owner = "icecc";
    repo = pname;
    rev = "v${version}";
    sha256 = "09jnipr67dhawbxfn69yh7mmjrkylgiqmd0gmc2limd3z15d7pgc";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules wrapQtAppsHook ];
  buildInputs = [ icecream qtbase libcap_ng lzo zstd libarchive ];

  meta = with lib; {
    description = "Icecream GUI Monitor";
    inherit (src.meta) homepage;
    license = licenses.gpl2;
    maintainers = with maintainers; [ emantor ];
    platforms = with platforms; linux ++ darwin;
  };
}
