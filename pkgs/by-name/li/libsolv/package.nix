{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, pkg-config
, zlib
, xz
, bzip2
, zchunk
, zstd
, expat
, withRpm ? !stdenv.hostPlatform.isDarwin
, rpm
, db
, withConda ? true
}:

stdenv.mkDerivation rec {
  version = "0.7.31";
  pname = "libsolv";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "libsolv";
    rev = version;
    hash = "sha256-3HOW3bip+0LKegwO773upeKKLiLv7JWUGEJcFiH0lcw=";
  };

  cmakeFlags =
    [
      (lib.cmakeBool "ENABLE_COMPLEX_DEPS" true)
      (lib.cmakeBool "ENABLE_CONDA" withConda)
      (lib.cmakeBool "ENABLE_LZMA_COMPRESSION" true)
      (lib.cmakeBool "ENABLE_BZIP2_COMPRESSION" true)
      (lib.cmakeBool "ENABLE_ZSTD_COMPRESSION" true)
      (lib.cmakeBool "ENABLE_ZCHUNK_COMPRESSION" true)
      (lib.cmakeBool "WITH_SYSTEM_ZCHUNK" true)
    ]
    ++ lib.optionals withRpm [
      (lib.cmakeBool "ENABLE_COMPS" true)
      (lib.cmakeBool "ENABLE_PUBKEY" true)
      (lib.cmakeBool "ENABLE_RPMDB" true)
      (lib.cmakeBool "ENABLE_RPMDB_BYRPMHEADER" true)
      (lib.cmakeBool "ENABLE_RPMMD" true)
    ];

  nativeBuildInputs = [ cmake ninja pkg-config ];
  buildInputs = [ zlib xz bzip2 zchunk zstd expat db ]
    ++ lib.optional withRpm rpm;

  meta = with lib; {
    description = "Free package dependency solver";
    homepage = "https://github.com/openSUSE/libsolv";
    license = licenses.bsd3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ copumpkin ];
  };
}
