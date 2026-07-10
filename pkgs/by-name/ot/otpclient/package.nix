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

stdenv.mkDerivation (finalAttrs: {
  pname = "otpclient";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "paolostivanin";
    repo = "otpclient";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KGtASCc07NGdjvQ8tIrnQIaEeld9H6z3odytKd8c5aQ=";
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

  meta = {
    description = "Highly secure and easy to use OTP client written in C/GTK that supports both TOTP and HOTP";
    homepage = "https://github.com/paolostivanin/OTPClient";
    changelog = "https://github.com/paolostivanin/OTPClient/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ alexbakker ];
    platforms = lib.platforms.linux;
  };
})
