{
  fetchFromGitHub,
  lib,
  libiconv,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "id3";
  version = "0.82";

  src = fetchFromGitHub {
    owner = "squell";
    repo = "id3";
    rev = finalAttrs.version;
    hash = "sha256-WwE+DotmA4Z5H4J5ShSWERk1K2QqvY01f8qnw0IRXR8=";
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
