{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  libressl,
  libevent,
}:

stdenv.mkDerivation rec {
  pname = "gmid";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "omar-polo";
    repo = "gmid";
    rev = version;
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

<<<<<<< HEAD
  meta = {
    description = "Simple and secure Gemini server";
    homepage = "https://gmid.omarpolo.com/";
    changelog = "https://gmid.omarpolo.com/changelog.html";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Simple and secure Gemini server";
    homepage = "https://gmid.omarpolo.com/";
    changelog = "https://gmid.omarpolo.com/changelog.html";
    license = licenses.isc;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
