{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  meson,
  ncurses,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "slurm-nm";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "mattthias";
    repo = "slurm";
    rev = "upstream/${version}";
    hash = "sha256-w77SIXFctMwwNw9cQm0HQaEaMs/5NXQjn1LpvkpCCB8=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];
  buildInputs = [ ncurses ];

<<<<<<< HEAD
  meta = {
    description = "Generic network load monitor";
    homepage = "https://github.com/mattthias/slurm";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ mikaelfangel ];
=======
  meta = with lib; {
    description = "Generic network load monitor";
    homepage = "https://github.com/mattthias/slurm";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ mikaelfangel ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "slurm";
  };
}
