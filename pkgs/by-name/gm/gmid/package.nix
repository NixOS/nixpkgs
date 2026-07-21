{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  libressl,
  libevent,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gmid";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "omar-polo";
    repo = "gmid";
    rev = finalAttrs.version;
    hash = "sha256-JyiGkVF9aRJXgWAwZEnGgaD+IiH3UzamfTAcWyN0now=";
  };

  nativeBuildInputs = [ bison ];

  buildInputs = [
    libressl
    libevent
  ];

  configureFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = {
    description = "Simple and secure Gemini server";
    homepage = "https://gmid.omarpolo.com/";
    changelog = "https://gmid.omarpolo.com/changelog.html";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.linux;
  };
})
