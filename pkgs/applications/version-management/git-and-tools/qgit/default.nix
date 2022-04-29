{ mkDerivation, lib, fetchFromGitHub, cmake, qtbase }:

mkDerivation rec {
  pname = "qgit";
  version = "2.10";

  src = fetchFromGitHub {
    owner = "tibirna";
    repo = "qgit";
    rev = "${pname}-${version}";
    sha256 = "1cwq43ywvii9zh4m31mgkgisfc9qhiixlz0zlv99skk9vb5v6r38";
  };

  buildInputs = [ qtbase ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    license = licenses.gpl2Only;
    homepage = "https://github.com/tibirna/qgit";
    description = "Graphical front-end to Git";
    maintainers = with maintainers; [ peterhoeg markuskowa ];
    inherit (qtbase.meta) platforms;
  };
}
