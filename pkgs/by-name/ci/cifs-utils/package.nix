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
  version = "7.4";

  src = fetchurl {
    url = "https://download.samba.org/pub/linux-cifs/cifs-utils/${pname}-${version}.tar.bz2";
    sha256 = "sha256-UzU9BcMLT8nawAao8MUFTN2KGDTBdjE8keRpQCXEuJE=";
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

  meta = with lib; {
    homepage = "https://wiki.samba.org/index.php/LinuxCIFS_utils";
    description = "Tools for managing Linux CIFS client filesystems";
    platforms = platforms.linux;
    license = licenses.lgpl3;
  };
}
