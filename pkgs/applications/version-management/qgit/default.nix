{
  mkDerivation,
  lib,
  fetchFromGitHub,
  cmake,
  qtbase,
}:

mkDerivation rec {
  pname = "qgit";
  version = "2.10";

  src = fetchFromGitHub {
    owner = "tibirna";
    repo = "qgit";
    rev = "${pname}-${version}";
    sha256 = "sha256-xM0nroWs4WByc2O469zVeAlzKn6LLr+8WDlEdSjtRYI=";
  };

  buildInputs = [ qtbase ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    license = licenses.gpl2Only;
    homepage = "https://github.com/tibirna/qgit";
    description = "Graphical front-end to Git";
    maintainers = with maintainers; [
      peterhoeg
      markuskowa
    ];
    inherit (qtbase.meta) platforms;
    mainProgram = "qgit";
  };
}
