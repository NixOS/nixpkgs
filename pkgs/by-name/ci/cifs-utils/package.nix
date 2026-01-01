{
  stdenv,
  lib,
  fetchurl,
  autoreconfHook,
  docutils,
  pkg-config,
  libcap,
  libkrb5,
  keyutils,
  pam,
  samba,
  talloc,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "cifs-utils";
<<<<<<< HEAD
  version = "7.5";

  src = fetchurl {
    url = "https://download.samba.org/pub/linux-cifs/cifs-utils/${pname}-${version}.tar.bz2";
    sha256 = "sha256-f6zoXj0tXrXnrb0YGt7mdZCX8TWxDW+zC+jgcK9+cFQ=";
=======
  version = "7.4";

  src = fetchurl {
    url = "https://download.samba.org/pub/linux-cifs/cifs-utils/${pname}-${version}.tar.bz2";
    sha256 = "sha256-UzU9BcMLT8nawAao8MUFTN2KGDTBdjE8keRpQCXEuJE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    autoreconfHook
    docutils
    pkg-config
  ];

  buildInputs = [
    keyutils
    libcap
    libkrb5
    pam
    python3
    samba
    talloc
  ];

  configureFlags = [
    "ROOTSBINDIR=$(out)/sbin"
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    # AC_FUNC_MALLOC is broken on cross builds.
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://wiki.samba.org/index.php/LinuxCIFS_utils";
    description = "Tools for managing Linux CIFS client filesystems";
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl3;
=======
  meta = with lib; {
    homepage = "https://wiki.samba.org/index.php/LinuxCIFS_utils";
    description = "Tools for managing Linux CIFS client filesystems";
    platforms = platforms.linux;
    license = licenses.lgpl3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
