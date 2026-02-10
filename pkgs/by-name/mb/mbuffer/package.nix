{
  lib,
  stdenv,
  fetchurl,
  openssl,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mbuffer";
  version = "20251025";
  outputs = [
    "out"
    "man"
  ];

  src = fetchurl {
    url = "http://www.maier-komor.de/software/mbuffer/mbuffer-${finalAttrs.version}.tgz";
    sha256 = "sha256-R+UWtBFgOZlnN8T4iV9m563iS37sXpN1SGY3psirNgE=";
  };

  buildInputs = [
    openssl
  ];
  nativeBuildInputs = [
    which
  ];
  nativeCheckInputs = [
    openssl
  ];

  doCheck = true;
  strictDeps = true;

  meta = {
    description = "Tool for buffering data streams with a large set of unique features";
    homepage = "https://www.maier-komor.de/mbuffer.html";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux; # Maybe other non-darwin Unix
    mainProgram = "mbuffer";
  };
})
