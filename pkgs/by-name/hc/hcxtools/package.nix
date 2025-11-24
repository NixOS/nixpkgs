{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  curl,
  openssl,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "hcxtools";
  version = "7.0.1";

  src = fetchFromGitHub {
    owner = "ZerBea";
    repo = "hcxtools";
    rev = version;
    sha256 = "sha256-WV5+1PQF999qSIMrIYApmIx6C+ovbKOtJDFglzxzSB4=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    curl
    openssl
    zlib
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "Tools for capturing wlan traffic and conversion to hashcat and John the Ripper formats";
    homepage = "https://github.com/ZerBea/hcxtools";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dywedir ];
  };
}
