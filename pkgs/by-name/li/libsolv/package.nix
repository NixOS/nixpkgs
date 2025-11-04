{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  zlib,
  xz,
  bzip2,
  zchunk,
  zstd,
  expat,
  withRpm ? !stdenv.hostPlatform.isDarwin,
  rpm,
  db,
  withConda ? true,
}:

stdenv.mkDerivation rec {
  __structuredAttrs = true;
  version = "0.7.35";
  pname = "libsolv";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "libsolv";
    rev = version;
    hash = "sha256-DHECjda7s12hSysbaXK2+wM/nXpAOpTn+eSf9XGC3z0=";
  };

  cmakeEntries = {
    ENABLE_COMPLEX_DEPS = true;
    ENABLE_CONDA = withConda;
    ENABLE_LZMA_COMPRESSION = true;
    ENABLE_BZIP2_COMPRESSION = true;
    ENABLE_ZSTD_COMPRESSION = true;
    ENABLE_ZCHUNK_COMPRESSION = true;
    WITH_SYSTEM_ZCHUNK = true;
  }
  // lib.optionalAttrs withRpm {
    ENABLE_COMPS = true;
    ENABLE_PUBKEY = true;
    ENABLE_RPMDB = true;
    ENABLE_RPMDB_BYRPMHEADER = true;
    ENABLE_RPMMD = true;
  };

  # Backward compatibility for those expecting `libsolv.cmakeFlags` to exist.
  # TODO(@ShamrockLee): Remove after ZHF.
  cmakeFlags = [ ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];
  buildInputs = [
    zlib
    xz
    bzip2
    zchunk
    zstd
    expat
    db
  ]
  ++ lib.optional withRpm rpm;

  meta = with lib; {
    description = "Free package dependency solver";
    homepage = "https://github.com/openSUSE/libsolv";
    license = licenses.bsd3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ ];
  };
}
