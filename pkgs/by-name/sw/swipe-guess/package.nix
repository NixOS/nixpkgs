{
  lib,
  stdenv,
  fetchFromSourcehut,
<<<<<<< HEAD
  scdoc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swipe-guess";
  version = "0.3.1";
=======
}:

stdenv.mkDerivation rec {
  pname = "swipe-guess";
  version = "0.2.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromSourcehut {
    owner = "~earboxer";
    repo = "swipeGuess";
<<<<<<< HEAD
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
=======
    rev = "v${version}";
    hash = "sha256-8bPsnqjLeeZ7btTre9j1T93VWY9+FdBdJdxyvBVt34s=";
  };

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    ${lib.getExe stdenv.cc} swipeGuess.c -o swipeGuess

    runHook postBuild
  '';

  postInstall = ''
    install -Dm555 swipeGuess -t $out/bin
  '';
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "Completion plugin for touchscreen-keyboards on mobile devices";
    homepage = "https://git.sr.ht/~earboxer/swipeGuess/";
    license = lib.licenses.agpl3Only;
    mainProgram = "swipeGuess";
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
