{
  buildPackages,
  lib,
  stdenv,
  fetchurl,
  gettext,
  libgpg-error,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libksba";
  version = "1.8.0";

  src = fetchurl {
    url = "mirror://gnupg/libksba/libksba-${finalAttrs.version}.tar.bz2";
    hash = "sha256-KWuduQlXSfKqEEIC16t/0JrRBxDgB4CnCcl1SxodkpI=";
  };

  outputs = [
    "out"
    "dev"
    "info"
  ];

  buildInputs = [ gettext ];
  propagatedBuildInputs = [ libgpg-error ];
  depsBuildBuild = [ buildPackages.stdenv.cc ];

  hardeningDisable = [ "strictflexarrays3" ];

  configureFlags = [ "--with-libgpg-error-prefix=${libgpg-error.dev}" ];

  postInstall = ''
    mkdir -p $dev/bin
    mv $out/bin/*-config $dev/bin/
    rmdir --ignore-fail-on-non-empty $out/bin
  '';

  meta = {
    homepage = "https://www.gnupg.org";
    description = "CMS and X.509 access library";
    mainProgram = "ksba-config";
    platforms = lib.platforms.all;
    maintainers = [ ];
    license = lib.licenses.lgpl3;
  };
})
