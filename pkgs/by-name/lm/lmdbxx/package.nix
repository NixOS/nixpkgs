{
  lib,
  stdenv,
  fetchFromGitHub,
  lmdb,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lmdbxx";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "hoytech";
    repo = "lmdbxx";
    rev = finalAttrs.version;
    sha256 = "sha256-//9dzddb0unW9fEy7POZZ/6SspHMzkZ/x5r/w10xu0o=";
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
