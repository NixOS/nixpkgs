{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, aml
, ffmpeg
, gnutls
, libjpeg_turbo
, mesa
, pixman
, zlib
}:

stdenv.mkDerivation rec {
  pname = "neatvnc";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "any1";
    repo = "neatvnc";
    rev = "v${version}";
    hash = "sha256-po7X3Gnt+mt1ZgJqvqe2fS5ITnKA0v2ZRB5NEjABGP8=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    aml
    ffmpeg
    gnutls
    libjpeg_turbo
    mesa
    pixman
    zlib
  ];

  mesonFlags = [
    (lib.mesonBool "tests" true)
  ];

  doCheck = true;

  meta = with lib; {
    description = "VNC server library";
    longDescription = ''
      This is a liberally licensed VNC server library that's intended to be
      fast and neat. Goals:
      - Speed
      - Clean interface
      - Interoperability with the Freedesktop.org ecosystem
    '';
    homepage = "https://github.com/any1/neatvnc";
    changelog = "https://github.com/any1/neatvnc/releases/tag/v${version}";
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nickcao ];
  };
}
