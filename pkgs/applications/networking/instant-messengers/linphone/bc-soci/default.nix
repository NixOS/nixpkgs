{
  cmake,
  fetchFromGitLab,
  fetchpatch,
  sqlite,
  boost,
  lib,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "bc-soci";
  # version retrieved from `CHANGELOG.md`
  version = "3.2.3-unstable-2025-05-05";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    group = "BC";
    owner = "public/external";
    repo = "soci";
    rev = "3a9c79088212941d0175c22cd2da8fe1bdd639df";
    sha256 = "sha256-7aSTFD4yk1i6c9cEGqdo/eJtuqoOUZUTJlZijgjuYpM=";
  };

  patches = [
    (fetchpatch {
      name = "fix-backend-search-path.patch";
      url = "https://github.com/SOCI/soci/commit/56c93afc467bdba8ffbe68739eea76059ea62f7a.patch";
      sha256 = "sha256-nC/39pn3Cv5e65GgIfF3l64/AbCsfZHPUPIWETZFZAY=";
    })
  ];

  cmakeFlags = [
    # Do not build static libraries
    "-DSOCI_SHARED=YES"
    "-DSOCI_STATIC=OFF"

    "-DSOCI_TESTS=NO"
    "-DWITH_SQLITE3=YES"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    sqlite
    boost
  ];

  meta = {
    description = "Database access library for C++. Belledonne Communications' fork for Linphone";
    homepage = "https://gitlab.linphone.org/BC/public/external/soci";
    license = lib.licenses.boost;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      naxdy
    ];
  };
}
