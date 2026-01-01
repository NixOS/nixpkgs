{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  libsForQt5,
<<<<<<< HEAD
  fetchpatch,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dotherside";
  version = "0.9.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "filcuc";
    repo = "dotherside";
    tag = "v${finalAttrs.version}";
    hash = "sha256-o6RMjJz9vtfCsm+F9UYIiYPEaQn+6EU5jOTLhNHCwo4=";
  };

<<<<<<< HEAD
  patches = [
    (fetchpatch {
      name = "bump-minimal-cmake-required-version.patch";
      url = "https://github.com/filcuc/dotherside/commit/56cb910b368ad0f8ef1f18ef52d46ab8136ca5d6.patch?full_index=1";
      hash = "sha256-xPMfSbTI8HWK6UYYFPATsz29lKbunm43JnaageTBZeY=";
    })
  ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtquickcontrols2
  ];

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
  ];

<<<<<<< HEAD
  meta = {
    description = "C language library for creating bindings for the Qt QML language";
    homepage = "https://filcuc.github.io/dotherside";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ toastal ];
=======
  meta = with lib; {
    description = "C language library for creating bindings for the Qt QML language";
    homepage = "https://filcuc.github.io/dotherside";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ toastal ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
