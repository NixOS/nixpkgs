{
  fetchFromGitHub,
  lib,
  libiconv,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "id3";
  version = "0.81-unstable-2026-06-07";

  src = fetchFromGitHub {
    owner = "squell";
    repo = "id3";
    rev = "6b78cd983a3eeb32eca515f5681ffbd8f73a5d95";
    hash = "sha256-QOhGZCqkXzDJb+62nYCkvj9UDDuhAT/BXcXIrE70CwA=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  makeFlags = [ "prefix=$(out)" ];

  meta = {
    description = "Portable command-line mass tagger";
    homepage = "https://squell.github.io/id3/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ jecaro ];
    platforms = lib.platforms.unix;
    mainProgram = "id3";
  };
})
