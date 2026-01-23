{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libpq,
  libgcrypt,
  pam,
  libxcrypt,
  unstableGitUpdater,
  nixosTests,
}:

stdenv.mkDerivation {
  pname = "pam-pgsql";
  version = "0-unstable-2025-01-24";

  src = fetchFromGitHub {
    owner = "pam-pgsql";
    repo = "pam-pgsql";
    rev = "7834ce21c4f633e3eadc9abe86fa02991efc43ed";
    hash = "sha256-hBkDEYZ8RBHav3tqDOD2uQ9m3U95wi4U9ebyQPqd5bo=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    libpq.pg_config
  ];

  buildInputs = [
    libgcrypt
    pam
    libpq
    libxcrypt
  ];

  passthru = {
    updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
    tests = { inherit (nixosTests) pam-pgsql; };
  };

  meta = {
    description = "Support to authenticate against PostgreSQL for PAM-enabled applications";
    homepage = "https://github.com/pam-pgsql/pam-pgsql";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ moraxyc ];
  };
}
