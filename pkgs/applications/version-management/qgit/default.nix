{
  mkDerivation,
  lib,
  fetchFromGitHub,
  cmake,
  qtbase,
}:

mkDerivation rec {
  pname = "qgit";
  version = "2.11";

  src = fetchFromGitHub {
    owner = "tibirna";
    repo = "qgit";
    rev = "${pname}-${version}";
    sha256 = "sha256-DmwxOy71mIklLQ7V/qMzi8qCMtKa9nWHlkjEr/9HJIU=";
  };

  buildInputs = [ qtbase ];

  nativeBuildInputs = [ cmake ];

  meta = {
    license = lib.licenses.gpl2Only;
    homepage = "https://github.com/tibirna/qgit";
    description = "Graphical front-end to Git";
    maintainers = with lib.maintainers; [
      peterhoeg
      markuskowa
    ];
    inherit (qtbase.meta) platforms;
    mainProgram = "qgit";
  };
}
