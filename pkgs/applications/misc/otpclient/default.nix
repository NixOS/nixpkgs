{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, gtk3
, wrapGAppsHook
, jansson
, libgcrypt
, libzip
, libpng
, libcotp
, protobuf
, protobufc
, qrencode
, libsecret
, libuuid
, zbar
}:

stdenv.mkDerivation rec {
  pname = "otpclient";
  version = "3.1.6";

  src = fetchFromGitHub {
    owner = "paolostivanin";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-v7TvdS0IlfB4oKdaEh7Z3AFJDV1bOMiX5vVD7VhIMCE=";
  };

  buildInputs = [ gtk3 jansson libgcrypt libzip libpng libcotp zbar protobuf protobufc libsecret qrencode libuuid ];
  nativeBuildInputs = [ cmake pkg-config wrapGAppsHook ];

  meta = with lib; {
    description = "Highly secure and easy to use OTP client written in C/GTK that supports both TOTP and HOTP";
    homepage = "https://github.com/paolostivanin/OTPClient";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ alexbakker ];
    platforms = platforms.linux;
  };
}
