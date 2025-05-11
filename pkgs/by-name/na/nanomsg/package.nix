{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nanomsg";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "nanomsg";
    repo = "nanomsg";
    tag = finalAttrs.version;
    hash = "sha256-yg8PpiIzIzRIkTztFyHmWOwYkeC9fGBwm1J9Rgr41jY=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Socket library that provides several common communication patterns";
    homepage = "https://nanomsg.org/";
    license = lib.licenses.mit;
    mainProgram = "nanocat";
    platforms = lib.platforms.unix;
  };
})
