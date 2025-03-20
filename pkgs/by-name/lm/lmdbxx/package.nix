{
  lib,
  stdenv,
  fetchFromGitHub,
  lmdb,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lmdbxx";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "hoytech";
    repo = "lmdbxx";
    rev = finalAttrs.version;
    sha256 = "sha256-7CxQZdgHVvmof6wVR9Mzic6tg89XJT3Z1ICGRs7PZYo=";
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
