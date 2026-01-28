{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  name = "hydra-menu";
  version = "0-unstable-2024-06-18";

  src = fetchFromGitHub {
    owner = "emad-elsaid";
    repo = "hydra";
    rev = "92d59e3a440eb9ebe098551ba972c894b1601f7f";
    hash = "sha256-dSwxIiFqfNp5OhTWl1OCc1XYgMG3pqYfXtQM7thvGOQ=";
  };

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "prefix="
  ];

  meta = with lib; {
    description = "C implementation of Emacs Hydra to be used in the terminal";
    homepage = "https://hydra.emadelsaid.com/";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ edrex ];
  };
}
