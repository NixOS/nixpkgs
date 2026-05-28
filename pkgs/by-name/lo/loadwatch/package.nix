{
  lib,
  stdenv,
  fetchFromSourcehut,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "loadwatch";
  version = "1.1-unstable-2026-05-04";

  src = fetchFromSourcehut {
    owner = "~woffs";
    repo = "loadwatch";
    rev = "f79b9cfad44a9f24aaab69cfad85a9ea14252b79";
    hash = "sha256-CNf3NpTbTfFQDg0G/I7ydH7ML4YNd8TlvPv8+RVa/sI=";
  };

  makeFlags = [ "bindir=$(out)/bin" ];

  meta = {
    description = "Run a program using only idle cycles";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ woffs ];
    platforms = lib.platforms.all;
  };
})
