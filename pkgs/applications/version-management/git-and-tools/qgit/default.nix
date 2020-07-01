{ mkDerivation, lib, fetchFromGitHub, cmake, qtbase }:

mkDerivation rec {
  pname = "qgit";
  version = "2.9";

  src = fetchFromGitHub {
    owner = "tibirna";
    repo = "qgit";
    rev = "${pname}-${version}";
    sha256 = "0n4dq9gffm9yd7n5p5qcdfgrmg2kwnfd51hfx10adgj9ibxlnc3z";
  };

  buildInputs = [ qtbase ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    license = licenses.gpl2;
    homepage = "https://github.com/tibirna/qgit";
    description = "Graphical front-end to Git";
    maintainers = with maintainers; [ peterhoeg markuskowa ];
    inherit (qtbase.meta) platforms;
  };
}
