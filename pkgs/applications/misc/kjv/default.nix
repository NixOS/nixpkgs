{ lib, stdenv, fetchFromGitHub, fetchpatch, readline }:

let
  patchPrefix = "https://web.archive.org/web/20220422205751/https://github.com/samuelgrf/kjv/commit/";

  add-apocrypha = fetchpatch {
    url = patchPrefix + "0856fa0d37b45de0d6b47d163b5ea9a0b7f2c061.patch";
    sha256 = "1jkajdg4wvpbbwc5mn37i4c8nfis4z0pv5rl7gqs0laj0gpj7jn8";
  };

  add-install-target = fetchpatch {
    url = patchPrefix + "50a83256ee45430fb06b7aea1945dd91c6813bc3.patch";
    sha256 = "0bv9yma67jdj496a6vn6y007c9gwjpg3rzld1i9m9y9xmlzq4yzv";
  };
in

stdenv.mkDerivation {
  pname = "kjv";
  version = "unstable-2021-03-11";

  src = fetchFromGitHub {
    owner = "bontibon";
    repo = "kjv";
    rev = "108595dcbb9bb12d40e0309f029b6fb3ccd81309";
    hash = "sha256-Z6myd9Xn23pYizG+IZVDrP988pYU06QIcpqXtWTcPiw=";
  };

  patches = [ add-apocrypha add-install-target ];

  buildInputs = [ readline ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "The Bible, King James Version";
    homepage = "https://github.com/bontibon/kjv";
    license = licenses.unlicense;
    maintainers = with maintainers; [ jtobin ];
    mainProgram = "kjv";
  };
}
