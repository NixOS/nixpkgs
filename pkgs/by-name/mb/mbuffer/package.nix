{
  lib,
  stdenv,
  fetchurl,
  openssl,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mbuffer";
  version = "20241007";
  outputs = [
    "out"
    "man"
  ];

  src = fetchurl {
    url = "http://www.maier-komor.de/software/mbuffer/mbuffer-${finalAttrs.version}.tgz";
    sha256 = "sha256-nXNjAQtO9FsWRva19QJ7SbtqIJxQL7hOKBx713HVa+0=";
  };

  buildInputs = [
    openssl
  ];
  nativeBuildInputs = [
    which
  ];

  doCheck = true;

  meta = {
    description = "Tool for buffering data streams with a large set of unique features";
    homepage = "https://www.maier-komor.de/mbuffer.html";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ehmry ];
    platforms = lib.platforms.linux; # Maybe other non-darwin Unix
    mainProgram = "mbuffer";
  };
})
