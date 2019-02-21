{ stdenv
, fetchFromGitHub
, openssl
, zlib
, libssh
, cmake
, perl
, pkgconfig
, rustPlatform
, curl
, libiconv
, CoreFoundation
, Security
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

  cargoSha256 = "08zbvjwjdpv2sbj6mh73py82inhs18jvmh8m9k4l94fcz6ykgqwr";

  nativeBuildInputs = [
    cmake
    pkgconfig
    perl
  ];

  buildInputs = [
    openssl
    libssh
    zlib
  ] ++ stdenv.lib.optionals (stdenv.isDarwin) [
    curl
    libiconv
    CoreFoundation
    Security
  ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Decentralized Issue Tracking for git";
    license = licenses.gpl2;
    maintainers = with maintainers; [ Profpatsch matthiasbeyer ];
  };
}
