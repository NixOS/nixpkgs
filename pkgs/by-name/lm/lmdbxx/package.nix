{
  lib,
  stdenv,
  fetchFromGitHub,
  lmdb,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lmdbxx";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "hoytech";
    repo = "lmdbxx";
    rev = finalAttrs.version;
    sha256 = "sha256-0c8Xev9Ys6beMQ9VD4S2o6N9R/w2eEz8iCxUiX7mW4E=";
  };

  buildInputs = [ lmdb ];
  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://github.com/hoytech/lmdbxx#readme";
    description = "C++11 wrapper for the LMDB embedded B+ tree database library";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ fgaz ];
  };
})
