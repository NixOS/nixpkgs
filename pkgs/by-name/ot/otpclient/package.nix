{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gtk3,
  wrapGAppsHook3,
  jansson,
  libgcrypt,
  libzip,
  libpng,
  libcotp,
  protobuf,
  protobufc,
  qrencode,
  libsecret,
  libuuid,
  zbar,
}:

stdenv.mkDerivation rec {
  pname = "otpclient";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "paolostivanin";
    repo = "otpclient";
    tag = "v${version}";
    hash = "sha256-zATGvp3ba7WP5ZV35OCOJkhE+0zAa4PQp01/9NOrFvk=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    jansson
    libcotp
    libgcrypt
    libpng
    libsecret
    libuuid
    libzip
    protobuf
    protobufc
    qrencode
    zbar
  ];

  meta = with lib; {
    description = "Highly secure and easy to use OTP client written in C/GTK that supports both TOTP and HOTP";
    homepage = "https://github.com/paolostivanin/OTPClient";
    changelog = "https://github.com/paolostivanin/OTPClient/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ alexbakker ];
    platforms = platforms.linux;
  };
}
