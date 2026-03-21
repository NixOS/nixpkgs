{
  lib,
  stdenv,
  fetchurl,
  openssl,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mbuffer";
  version = "20260301";
  outputs = [
    "out"
    "man"
  ];

  src = fetchurl {
    url = "http://www.maier-komor.de/software/mbuffer/mbuffer-${finalAttrs.version}.tgz";
    sha256 = "sha256-t7L+huJLLzCcQlDWo4pD4sjuL5hFYZECSWSMODzbwtA=";
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

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Tool for buffering data streams with a large set of unique features";
    homepage = "https://www.maier-komor.de/mbuffer.html";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    mainProgram = "mbuffer";
  };
})
