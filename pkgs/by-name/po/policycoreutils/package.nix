{
  lib,
  stdenv,
  fetchurl,
  gettext,
  libsepol,
  libselinux,
  libsemanage,
  libxcrypt,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "policycoreutils";
  version = "3.10";
  inherit (libsepol) se_url;

  src = fetchurl {
    url = "${finalAttrs.se_url}/${finalAttrs.version}/policycoreutils-${finalAttrs.version}.tar.gz";
    hash = "sha256-jb1Q2Gisv66dGpcva7slh/BsnsczCNEa9qyzpAHemDI=";
  };

  postPatch = ''
    # Fix install references
    substituteInPlace po/Makefile \
       --replace /usr/bin/install install --replace /usr/share /share
    substituteInPlace newrole/Makefile --replace /usr/share /share
  '';

  nativeBuildInputs = [
    gettext
    pkg-config
  ];
  buildInputs = [
    libsepol
    libselinux
    libsemanage
    libxcrypt
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "SBINDIR=$(out)/bin"
    "ETCDIR=$(out)/etc"
    "BASHCOMPLETIONDIR=$out/share/bash-completion/completions"
    "LOCALEDIR=$(out)/share/locale"
    "MAN5DIR=$(out)/share/man/man5"
  ];

  meta = {
    description = "SELinux policy core utilities";
    license = lib.licenses.gpl2Only;
    inherit (libsepol.meta) homepage platforms maintainers;
  };
})
