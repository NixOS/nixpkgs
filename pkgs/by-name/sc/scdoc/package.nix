{
  lib,
  stdenv,
  fetchFromSourcehut,
  buildPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scdoc";
<<<<<<< HEAD
  version = "1.11.4";
=======
  version = "1.11.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "scdoc";
    rev = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-gldCHzLigeLKDFDcE3TYrNOEWoSt/uYIg9aTg6wwW54=";
=======
    hash = "sha256-MbLDhLn/JY6OcdOz9/mIPAQRp5TZ6IKuQ/FQ/R3wjGc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  outputs = [
    "out"
    "man"
    "dev"
  ];

<<<<<<< HEAD
=======
  postPatch = ''
    substituteInPlace Makefile \
      --replace "LDFLAGS+=-static" "LDFLAGS+="
  '';

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "HOST_SCDOC=${lib.getExe buildPackages.scdoc}"
  ];

  doCheck = true;

  meta = {
    description = "Simple man page generator written in C99 for POSIX systems";
    homepage = "https://git.sr.ht/~sircmpwn/scdoc";
    changelog = "https://git.sr.ht/~sircmpwn/scdoc/refs/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    mainProgram = "scdoc";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
