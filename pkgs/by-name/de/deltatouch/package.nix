{
  lib,
  stdenv,
  fetchFromGitea,
  fetchFromGitHub,
<<<<<<< HEAD
=======
  fetchpatch,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    version = "2.25.0";
=======
    version = "2.22.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    src = fetchFromGitHub {
      owner = "chatmail";
      repo = "core";
      tag = "v${version}";
<<<<<<< HEAD
      hash = "sha256-pW1+9aljtnYJmlJOj+m0aQekYO5IsL0fduR7kIAPdN8=";
=======
      hash = "sha256-DKqqdcG3C7/RF/wz2SqaiPUjZ/7vMFJTR5DIGTXjoTY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };
    cargoDeps = rustPlatform.fetchCargoVendor {
      pname = "chatmail-core";
      inherit version src;
<<<<<<< HEAD
      hash = "sha256-iIC9wE7P2SKeCMtc/hFTRaOGXD2F7kh1TptOoes/Qi0=";
=======
      hash = "sha256-x71vytk9ytIhHlRR0lDhDcIaDNJGDdPwb6fkB1SI+NQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "deltatouch";
<<<<<<< HEAD
  version = "2.25.1";
=======
  version = "2.22.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "lk108";
    repo = "deltatouch";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-0+5wZCadYHmZjp/Za0LmK7FWq9nfyhXZFAx0lGqfRK0=";
  };

=======
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

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
