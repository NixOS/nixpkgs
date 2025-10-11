{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "zip";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "kuba--";
    repo = "zip";
    rev = "v${version}";
    hash = "sha256-wNkIYuwwXo7v3vNaOnRZt1tcd0RGjDvCUqDGdvJzVdo=";
  };

  nativeBuildInputs = [
    cmake
  ];

  doCheck = true;

  meta = {
    description = "A portable, simple zip library written in C";
    homepage = "https://github.com/kuba--/zip";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nim65s ];
    # OSX/Linux/Windows/Android/iOS
    platforms = lib.platforms.all;
  };
}
