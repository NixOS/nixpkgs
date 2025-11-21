{
  lib,
  stdenv,
  fetchFromGitea,
  fetchFromGitHub,
  cmake,
  intltool,
  libdeltachat,
  lomiri,
  qt5,
  quirc,
  rustPlatform,
}:

let
  libdeltachat' = libdeltachat.overrideAttrs rec {
    version = "2.25.0";
    src = fetchFromGitHub {
      owner = "chatmail";
      repo = "core";
      tag = "v${version}";
      hash = "sha256-pW1+9aljtnYJmlJOj+m0aQekYO5IsL0fduR7kIAPdN8=";
    };
    cargoDeps = rustPlatform.fetchCargoVendor {
      pname = "chatmail-core";
      inherit version src;
      hash = "sha256-iIC9wE7P2SKeCMtc/hFTRaOGXD2F7kh1TptOoes/Qi0=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "deltatouch";
  version = "2.25.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "lk108";
    repo = "deltatouch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0+5wZCadYHmZjp/Za0LmK7FWq9nfyhXZFAx0lGqfRK0=";
  };

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
    intltool
    cmake
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qtwebengine
    qt5.qtquickcontrols2
    libdeltachat'
    lomiri.lomiri-ui-toolkit
    lomiri.lomiri-ui-extras
    lomiri.lomiri-api
    lomiri.qqc2-suru-style
    quirc
  ];

  meta = {
    changelog = "https://codeberg.org/lk108/deltatouch/src/tag/${finalAttrs.src.tag}/CHANGELOG";
    description = "Messaging app for Ubuntu Touch, powered by Delta Chat core";
    longDescription = ''
      DeltaTouch is a messenger for Ubuntu Touch based on Delta Chat core.
      Delta Chat works over email.
    '';
    homepage = "https://codeberg.org/lk108/deltatouch";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ link2xt ];
    mainProgram = "deltatouch";
    platforms = lib.platforms.linux;
  };
})
