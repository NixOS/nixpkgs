{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clap";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "free-audio";
    repo = "clap";
    rev = finalAttrs.version;
    hash = "sha256-st8K6hmU2qa01qvHCe6NNnjXwx5k0ABZKZBjp5II7B8=";
  };

  postPatch = ''
    substituteInPlace clap.pc.in \
      --replace '$'"{prefix}/@CMAKE_INSTALL_INCLUDEDIR@" '@CMAKE_INSTALL_FULL_INCLUDEDIR@'
  '';

  nativeBuildInputs = [ cmake ];

  passthru.tests.pkg-config = testers.hasPkgConfigModules { package = finalAttrs.finalPackage; };

  meta = with lib; {
    description = "Clever Audio Plugin API interface headers";
    homepage = "https://cleveraudio.org/";
    pkgConfigModules = [ "clap" ];
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ ris ];
  };
})
