{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
}:

stdenv.mkDerivation {
  pname = "raul";
  version = "2.0.0-unstable-2024-07-04";

  src = fetchFromGitLab {
    owner = "drobilla";
    repo = "raul";
    rev = "9097952a918f8330a5db9039ad390fc2457f841d";
    hash = "sha256-k+EU3ROVJyjJPAtNxPmRXp9DALpUHzohCLL6Xe3NUxk=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  strictDeps = true;

  meta = {
    description = "C++ utility library primarily aimed at audio/musical applications";
    homepage = "http://drobilla.net/software/raul";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ t4ccer ];
    platforms = lib.platforms.unix;
  };
}
