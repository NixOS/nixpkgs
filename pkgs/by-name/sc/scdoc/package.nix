{ lib
, stdenv
, fetchFromSourcehut
, buildPackages
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scdoc";
  version = "1.11.2-unstable-2023-03-08";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "scdoc";
    rev = "afeda241f3f9b2c27e461f32d9c2a704ab82ef61";
    hash = "sha256-jIYygjUXP/6o5d9drlZjdr25KjEQx8oy4TaQwQEu8fM=";
  };

  outputs = [ "out" "man" "dev" ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace "LDFLAGS+=-static" "LDFLAGS+="
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "HOST_SCDOC=${lib.getExe buildPackages.scdoc}"
  ];

  doCheck = true;

  meta = {
    description = "A simple man page generator written in C99 for POSIX systems";
    homepage = "https://git.sr.ht/~sircmpwn/scdoc";
    changelog = "https://git.sr.ht/~sircmpwn/scdoc/refs/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    mainProgram = "scdoc";
    maintainers = with lib.maintainers; [ primeos AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
