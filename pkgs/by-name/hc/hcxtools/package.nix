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
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "ZerBea";
    repo = "hcxtools";
    rev = version;
    sha256 = "sha256-gL1OnNtd6cqW0kM3w2wHc0UU3JvC6H2kQg1aBDaN11U=";
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
