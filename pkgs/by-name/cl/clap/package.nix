{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clap";
  version = "1.2.7";

  src = fetchFromGitHub {
    owner = "free-audio";
    repo = "clap";
    rev = finalAttrs.version;
    hash = "sha256-FtsqfpUBn0YGEyhRrJnPGSqrawS1g3F/exVGAuvXkRQ=";
  };

  postPatch = ''
    substituteInPlace clap.pc.in \
      --replace '$'"{prefix}/@CMAKE_INSTALL_INCLUDEDIR@" '@CMAKE_INSTALL_FULL_INCLUDEDIR@'
  '';

  nativeBuildInputs = [ cmake ];

  passthru.tests.pkg-config = testers.hasPkgConfigModules { package = finalAttrs.finalPackage; };

  meta = {
    description = "Clever Audio Plugin API interface headers";
    homepage = "https://cleveraudio.org/";
    pkgConfigModules = [ "clap" ];
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ris ];
  };
})
