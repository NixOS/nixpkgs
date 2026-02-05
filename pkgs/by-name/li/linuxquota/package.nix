{
  lib,
  stdenv,
  fetchurl,
  e2fsprogs,
  openldap,
  pkg-config,
  binlore,
  linuxquota,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "4.11";
  pname = "quota";

  src = fetchurl {
    url = "mirror://sourceforge/linuxquota/quota-${finalAttrs.version}.tar.gz";
    hash = "sha256-ClG4+SAlTY6Dw0pMMIK30kH11v1lGIr63ymFnVIj73g=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
    "man"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    e2fsprogs
    openldap
  ];

  passthru.binlore.out = binlore.synthesize linuxquota ''
    execer cannot bin/quota
  '';

  meta = {
    description = "Tools to manage kernel-level quotas in Linux";
    homepage = "https://sourceforge.net/projects/linuxquota/";
    license = lib.licenses.gpl2Plus; # With some files being BSD as an exception
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.dezgeg ];
  };
})
