{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  curl,
  openssl,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hcxtools";
  version = "7.1.2";

  src = fetchFromGitHub {
    owner = "ZerBea";
    repo = "hcxtools";
    rev = finalAttrs.version;
    sha256 = "sha256-v33RpDKA4OeUU4YXXWhHpdlqQvxk4HIWQKCPskdTSTU=";
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

  meta = {
    description = "Tools for capturing wlan traffic and conversion to hashcat and John the Ripper formats";
    homepage = "https://github.com/ZerBea/hcxtools";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ dywedir ];
  };
})
