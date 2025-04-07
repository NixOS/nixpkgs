{
  lib,
  stdenv,
  fetchurl,
  gettext,
  libsepol,
  libselinux,
  libsemanage,
  libxcrypt,
}:

stdenv.mkDerivation rec {
  pname = "policycoreutils";
  version = "3.8.1";
  inherit (libsepol) se_url;

  src = fetchurl {
    url = "${se_url}/${version}/policycoreutils-${version}.tar.gz";
    hash = "sha256-7vIxlrUB0UHLlfX8Uu8acon0WbZeRBXqD+mu7cXYDvI=";
  };

  postPatch = ''
    # Fix install references
    substituteInPlace po/Makefile \
       --replace /usr/bin/install install --replace /usr/share /share
    substituteInPlace newrole/Makefile --replace /usr/share /share
  '';

  nativeBuildInputs = [ gettext ];
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

  meta = with lib; {
    description = "SELinux policy core utilities";
    license = licenses.gpl2Only;
    inherit (libsepol.meta) homepage platforms maintainers;
  };
}
