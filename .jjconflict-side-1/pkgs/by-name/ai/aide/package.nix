{
  lib,
  stdenv,
  fetchurl,
  flex,
  bison,
  libmhash,
  zlib,
  acl,
  attr,
  libselinux,
  pcre2,
  pkg-config,
  libgcrypt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aide";
  version = "0.19.4";

  src = fetchurl {
    # We specifically want the tar.gz, so fetchFromGitHub is not suitable here
    url = "https://github.com/aide/aide/releases/download/v${finalAttrs.version}/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    hash = "sha256-R6t8aW8HRZEUeaQfkNetmdJlNuGG1mxKrQk7xy0g/18=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    flex
    bison
    libmhash
    zlib
    acl
    attr
    libselinux
    pcre2
    libgcrypt
  ];

  configureFlags = [
    "--with-posix-acl"
    "--with-selinux"
    "--with-xattr"
    "--sysconfdir=/etc"
  ];

  meta = {
    homepage = "https://aide.github.io/";
    changelog = "https://github.com/aide/aide/blob/v${finalAttrs.version}/ChangeLog";
    description = "File and directory integrity checker";
    mainProgram = "aide";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ happysalada ];
    platforms = lib.platforms.linux;
  };
})
