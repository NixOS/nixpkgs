{ stdenv
, fetchFromGitHub
, openssl
, gcc
, zlib
, libssh
, cmake
, perl
, pkgconfig
, rustPlatform
}:

with rustPlatform;

buildRustPackage rec {
  name = "git-dit-${version}";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "neithernut";
    repo = "git-dit";
    rev = "v${version}";
    sha256 = "1sx6sc2dj3l61gbiqz8vfyhw5w4xjdyfzn1ixz0y8ipm579yc7a2";
  };

  depsSha256 = "1z2n3z5wkh5z5vc976yscq77fgjszwzwlrp7g17hmsbhzx6x170h";

  nativeBuildInputs = [
    cmake
    pkgconfig
    perl
  ];

  buildInputs = [
    openssl
    libssh
    zlib
  ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Decentralized Issue Tracking for git";
    license = licenses.gpl2;
    maintainers = with maintainers; [ profpatsch matthiasbeyer ];
  };
}
