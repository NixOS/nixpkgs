{
  lib,
  stdenv,
  fetchFromSourcehut,
  buildPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scdoc";
  version = "1.11.3";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "scdoc";
    rev = finalAttrs.version;
    hash = "sha256-MbLDhLn/JY6OcdOz9/mIPAQRp5TZ6IKuQ/FQ/R3wjGc=";
  };

  outputs = [
    "out"
    "man"
    "dev"
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace "LDFLAGS+=-static" "LDFLAGS+="
  '';

  makeFlags =
    [
      "PREFIX=${placeholder "out"}"
    ]
    ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
      "HOST_SCDOC=${lib.getExe buildPackages.scdoc}"
    ];

  doCheck = true;

  meta = {
    description = "A simple man page generator written in C99 for POSIX systems";
    homepage = "https://git.sr.ht/~sircmpwn/scdoc";
    changelog = "https://git.sr.ht/~sircmpwn/scdoc/refs/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    mainProgram = "scdoc";
    maintainers = with lib.maintainers; [
      primeos
      AndersonTorres
    ];
    platforms = lib.platforms.unix;
  };
})
