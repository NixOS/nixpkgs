{
  lib,
  stdenv,
  fetchFromSourcehut,
  scdoc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swipe-guess";
  version = "0.3.1";

  src = fetchFromSourcehut {
    owner = "~earboxer";
    repo = "swipeGuess";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zpV7A42wzoRZBpDBQUKGFCnLNJELqQE69fJTx8TN4uE=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "docs words-qwerty-en" "docs" \
      --replace-fail 'install -m644 words-qwerty-en -D -t "$(DESTDIR)/$(PREFIX)/share/swipeGuess/words/"' ""
  '';

  nativeBuildInputs = [ scdoc ];

  makeFlags = [
    "PREFIX="
    "DESTDIR=${placeholder "out"}"
  ];

  meta = {
    description = "Completion plugin for touchscreen-keyboards on mobile devices";
    homepage = "https://git.sr.ht/~earboxer/swipeGuess/";
    license = lib.licenses.agpl3Only;
    mainProgram = "swipeGuess";
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
