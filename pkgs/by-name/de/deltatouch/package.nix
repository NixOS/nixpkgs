{
  lib,
  stdenv,
  fetchFromGitea,
  fetchFromGitHub,
  fetchpatch,
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
    version = "2.22.0";
    src = fetchFromGitHub {
      owner = "chatmail";
      repo = "core";
      tag = "v${version}";
      hash = "sha256-DKqqdcG3C7/RF/wz2SqaiPUjZ/7vMFJTR5DIGTXjoTY=";
    };
    cargoDeps = rustPlatform.fetchCargoVendor {
      pname = "chatmail-core";
      inherit version src;
      hash = "sha256-x71vytk9ytIhHlRR0lDhDcIaDNJGDdPwb6fkB1SI+NQ=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "deltatouch";
  version = "2.22.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "lk108";
    repo = "deltatouch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e8kS6kAjOZ2V33XJuJbvDZ9mfRknDh9un0dn5HtD3UY=";
  };

  patches = [
    (fetchpatch {
      url = "https://codeberg.org/lk108/deltatouch/commit/b19c088ce95e8ca6ff1102c36d91b1db937e3a3a.patch";
      hash = "sha256-58WPUSFaAUqVVU3iq05tae5Gvvr405zDA145V9DbJ54=";
    })
    (fetchpatch {
      url = "https://codeberg.org/lk108/deltatouch/commit/139f3a4abd772b17142a7f61ef9b442200728f4a.patch";
      hash = "sha256-bEX4g88CCt7AFok8kTeItzCripXFoG2ED7R9lGYoCAw=";
    })
  ];

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
