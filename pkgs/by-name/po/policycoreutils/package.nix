{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  gettext,
  libsepol,
  libselinux,
  libsemanage,
  libxcrypt,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "policycoreutils";
  version = "3.11";
  inherit (libsepol) se_url;

  src = fetchurl {
    url = "${finalAttrs.se_url}/${finalAttrs.version}/policycoreutils-${finalAttrs.version}.tar.gz";
    hash = "sha256-BU5B7AOXMaXua3l6jguNbjRu4dCpusLyUttIwj+aixs=";
  };

  patches = [
    # https://nvd.nist.gov/vuln/detail/CVE-2026-19079
    (fetchpatch {
      name = "CVE-2026-19079.patch";
      url = "https://github.com/SELinuxProject/selinux/commit/a556538c2d5d2583273e025b45c02651fef47679.patch";
      stripLen = 1;
      hash = "sha256-na/4xfW1R5VwvwHTUHXSs23pOD8Z/ClbBET+oxJe+uA=";
    })
  ];

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
