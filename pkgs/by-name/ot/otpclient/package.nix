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
<<<<<<< HEAD
  version = "4.2.0";
=======
  version = "4.1.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "paolostivanin";
    repo = "otpclient";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-KGtASCc07NGdjvQ8tIrnQIaEeld9H6z3odytKd8c5aQ=";
=======
    hash = "sha256-yve6DMtMqPTkyI01lRvJy0rObEt9KMrekjPegjT5blk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
    changelog = "https://github.com/paolostivanin/OTPClient/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ alexbakker ];
    platforms = lib.platforms.linux;
  };
}
