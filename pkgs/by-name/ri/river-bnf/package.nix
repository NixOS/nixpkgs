{ lib
, stdenv
, fetchFromSourcehut
, wayland
, wayland-scanner
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "river-bnf";
  version = "unstable-2023-10-10";

  src = fetchFromSourcehut {
    owner = "~leon_plickat";
    repo = pname;
    rev = "bb8ded380ed5d539777533065b4fd33646ad5603";
    hash = "sha256-rm9Nt3WLgq9QOXzrkYBGp45EALNYFTQGInxfYIN0XcU=";
  };

  nativeBuildInputs = [
    wayland-scanner
  ];

  buildInputs = [
    wayland.dev
  ];

  postPatch = ''
    substituteInPlace Makefile --replace '/usr/local' $out
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Switch back'n'forth between river tags";
    homepage = "https://git.sr.ht/~leon_plickat/river-bnf";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ adamcstephens ];
    mainProgram = "river-bnf";
    platforms = lib.platforms.linux;
  };
}
