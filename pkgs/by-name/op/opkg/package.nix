{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  curl,
  gpgme,
  libarchive,
  bzip2,
  xz,
  attr,
  acl,
  libxml2,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opkg";
  version = "0.8.0";

  src = fetchurl {
    url = "https://git.yoctoproject.org/opkg/snapshot/opkg-${finalAttrs.version}.tar.gz";
    hash = "sha256-3vDW6VtBBr4HTA/OWgyqDo1zfyH+Mfvu8ViFl7rTlmY=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    curl
    gpgme
    libarchive
    bzip2
    xz
    attr
    acl
    libxml2
  ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  meta = {
    description = "Lightweight package management system based upon ipkg";
    homepage = "https://git.yoctoproject.org/cgit/cgit.cgi/opkg/";
    changelog = "https://git.yoctoproject.org/opkg/tree/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pSub ];
  };
})
