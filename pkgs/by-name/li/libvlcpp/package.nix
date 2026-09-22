{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  libvlc,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libvlcpp";
  version = "0.1.0-unstable-2026-04-16";

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "videolan";
    repo = "libvlcpp";
    rev = "33214afee13df36dc46309ef5416d681b56db5b9";
    hash = "sha256-PjJzFrvkmrTsBjzmEG6hNU8VzDlofQrdfTGFhxkVPWU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  propagatedBuildInputs = [
    libvlc
  ];

  doCheck = true;

  meta = {
    description = "Header-only C++ bindings for the libvlc crossplatform multimedia API";
    homepage = "https://code.videolan.org/videolan/libvlcpp";
    maintainers = with lib.maintainers; [ l33tname ];
    platforms = lib.platforms.all;
    license = lib.licenses.lgpl21Only;
  };
})
