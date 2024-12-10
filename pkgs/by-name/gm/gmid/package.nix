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
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "omar-polo";
    repo = pname;
    rev = version;
    hash = "sha256-5K6+CVX0/m6SBcTvwy4GD0x9R/yQjd+2tTJiA4OagcI=";
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
    license = licenses.isc;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.linux;
  };
}
