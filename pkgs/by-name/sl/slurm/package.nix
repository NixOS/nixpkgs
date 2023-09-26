{ lib
, stdenv
, fetchFromGitHub
, meson
, ncurses6
, ninja
}:

stdenv.mkDerivation rec {
  pname = "slurm";
  version = "0.4.4";
  src = fetchFromGitHub {
    owner = "mattthias";
    repo = "slurm";
    rev = "upstream/${version}";
    hash = "sha256-w77SIXFctMwwNw9cQm0HQaEaMs/5NXQjn1LpvkpCCB8=";
  };

  buildInputs = [meson ncurses6 ninja];

  buildPhase = ''
    meson setup
    meson compile
  '';

  installPhase = ''
    meson install
  '';

  meta = with lib; {
    description = "yet another network load monitor";
    homepage = "https://github.com/mattthias/slurm";
    license = licenses.gpl2Only;
    platforms = with platforms; [ linux ];
    maintainers = with lib.maintainers; [ redxtech ];
  };
}

