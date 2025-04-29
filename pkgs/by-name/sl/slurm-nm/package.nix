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

  meta = with lib; {
    description = "Generic network load monitor";
    homepage = "https://github.com/mattthias/slurm";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ mikaelfangel ];
    mainProgram = "slurm";
  };
}
