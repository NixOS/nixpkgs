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
  version = "4.10";
  pname = "quota";

  src = fetchurl {
    url = "mirror://sourceforge/linuxquota/quota-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-oEoMr8opwVvotqxmDgYYi8y4AsGe/i58Ge1/PWZ+z14=";
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
