{
  buildPackages,
  lib,
  stdenv,
  fetchurl,
  gettext,
  libgpg-error,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libksba";
  version = "1.9.0";

  src = fetchurl {
    url = "mirror://gnupg/libksba/libksba-${finalAttrs.version}.tar.bz2";
    hash = "sha256-sHDz2pET3zgEN59V4QzQDwvEmT1TkhV/7LX9F0pdWM4=";
  };

  outputs = [
    "out"
    "dev"
    "info"
  ];

  buildInputs = [ gettext ];
  propagatedBuildInputs = [ libgpg-error ];
  depsBuildBuild = [ buildPackages.stdenv.cc ];

  strictDeps = true;

  hardeningDisable = [ "strictflexarrays3" ];

  configureFlags = [ "--with-libgpg-error-prefix=${libgpg-error.dev}" ];

  postInstall = ''
    mkdir -p $dev/bin
    mv $out/bin/*-config $dev/bin/
    rmdir --ignore-fail-on-non-empty $out/bin
  '';

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  __structuredAttrs = true;

  meta = {
    homepage = "https://www.gnupg.org";
    description = "CMS and X.509 access library";
    mainProgram = "ksba-config";
    platforms = lib.platforms.all;
    maintainers = [ ];
    license = lib.licenses.lgpl3;
    pkgConfigModules = [ "ksba" ];
  };
})
