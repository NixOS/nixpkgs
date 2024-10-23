{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  vlc,
  libvlc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libvlcpp";
  version = "0.1.0-unstable-2024-02-04";

  src = fetchFromGitLab {
    owner = "videolan";
    repo = "libvlcpp";
    domain = "code.videolan.org";
    rev = "44c1f48e56a66c3f418175af1e1ef3fd1ab1b118";
    sha256 = "sha256-nnS4DMz/2VciCrhOBGRb1+kDbxj+ZOnEtQmzs/TJ870=";
  };

  propagatedBuildInputs = [
    vlc
    libvlc
  ];
  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  doCheck = true;

  meta = {
    description = "A header-only, C++ bindings for the libvlc crossplatform multimedia API";
    homepage = "https://code.videolan.org/videolan/libvlcpp";
    maintainers = with lib.maintainers; [ l33tname ];
    platforms = lib.platforms.all;
    license = lib.licenses.lgpl21Only;
  };
})
