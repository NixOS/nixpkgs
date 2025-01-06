{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  SDL2,
}:

#TODO: tests

stdenv.mkDerivation rec {
  pname = "faudio";
  version = "25.01";

  src = fetchFromGitHub {
    owner = "FNA-XNA";
    repo = "FAudio";
    rev = version;
    sha256 = "sha256-k/cu8yqrwohpr37oZNBi7+Ln+Fj0TGXkl5VmdcjZB1o=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ SDL2 ];

  meta = {
    description = "XAudio reimplementation focusing to develop a fully accurate DirectX audio library";
    homepage = "https://github.com/FNA-XNA/FAudio";
    changelog = "https://github.com/FNA-XNA/FAudio/releases/tag/${version}";
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.marius851000 ];
  };
}
