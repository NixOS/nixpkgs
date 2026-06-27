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

stdenv.mkDerivation (finalAttrs: {
  pname = "cifs-utils";
  version = "7.6";

  src = fetchurl {
    url = "https://download.samba.org/pub/linux-cifs/cifs-utils/cifs-utils-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-fbh1/yho5fpORFraC9I+pwuRYblhiMfidjIeBh7VHdY=";
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
    "ROOTSBINDIR=$(bin)/sbin"
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    # AC_FUNC_MALLOC is broken on cross builds.
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

  outputs = [
    "out"
    "bin"
    "man"
    "dev"
  ];

  meta = {
    homepage = "https://wiki.samba.org/index.php/LinuxCIFS_utils";
    description = "Tools for managing Linux CIFS client filesystems";
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl3;
  };
})
