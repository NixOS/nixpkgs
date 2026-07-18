{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gtk4,
  wrapGAppsHook3,
  jansson,
  libgcrypt,
  libadwaita,
  libpng,
  libcotp,
  glib,
  protobufc,
  qrencode,
  libsecret,
  libuuid,
  zbar,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "otpclient";
  version = "5.1.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "paolostivanin";
    repo = "otpclient";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sKXxujzHNQUZj9XloQLsZR12ZhyiY+512FOqgkTrxyQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk4
    glib
    libadwaita
    jansson
    libcotp
    libgcrypt
    libpng
    libsecret
    libuuid
    protobufc
    qrencode
    zbar
  ];

  meta = {
    description = "Highly secure and easy to use OTP client written in C/GTK that supports both TOTP and HOTP";
    homepage = "https://github.com/paolostivanin/OTPClient";
    changelog = "https://github.com/paolostivanin/OTPClient/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ alexbakker ];
    platforms = lib.platforms.linux;
  };
})
