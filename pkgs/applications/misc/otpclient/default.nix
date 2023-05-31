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
  version = "3.1.7";

  src = fetchFromGitHub {
    owner = "paolostivanin";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-TklVOUkdhWDG9GqHl0Sz9fah+Xp/M8xgSuDB1q4mljM=";
  };

  buildInputs = [ gtk3 jansson libgcrypt libzip libpng libcotp zbar protobuf protobufc libsecret qrencode libuuid ];
  nativeBuildInputs = [ cmake pkg-config wrapGAppsHook ];

  meta = with lib; {
    description = "Highly secure and easy to use OTP client written in C/GTK that supports both TOTP and HOTP";
    homepage = "https://github.com/paolostivanin/OTPClient";
    changelog = "https://github.com/paolostivanin/OTPClient/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ alexbakker ];
    platforms = platforms.linux;
  };
}
