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
    repo = pname;
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

  meta = with lib; {
    description = "Simple and secure Gemini server";
    homepage = "https://gmid.omarpolo.com/";
    changelog = "https://gmid.omarpolo.com/changelog.html";
    license = licenses.isc;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.linux;
  };
}
