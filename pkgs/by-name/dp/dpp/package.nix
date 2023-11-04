{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, zlib
, openssl
, libsodium
, libopus
}:

stdenv.mkDerivation rec {
  pname = "dpp";
  version = "10.0.29";

  src = fetchFromGitHub {
    owner = "brainboxdotcc";
    repo = "DPP";
    rev = "v${version}";
    sha256 = "sha256-BJMg3MLSfb9x/2lPHITeI3SWwW1OZVUUMVltTWUcw9I=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ zlib openssl libsodium libopus ];

  meta = with lib; {
    description = "Lightweight and efficient library for Discord written in modern C++";
    homepage = "https://dpp.dev/index.html";
    license = licenses.asl20;
    maintainers = with maintainers; [ pongo1231 ];
    platforms = platforms.unix;
  };
}
