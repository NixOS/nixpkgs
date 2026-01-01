{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clap";
<<<<<<< HEAD
  version = "1.2.7";
=======
  version = "1.2.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "free-audio";
    repo = "clap";
    rev = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-FtsqfpUBn0YGEyhRrJnPGSqrawS1g3F/exVGAuvXkRQ=";
=======
    hash = "sha256-QyIuuiwFg5DP2Ao/LOKYiBXxKHQ0FbFhssIIUnEQz+c=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    substituteInPlace clap.pc.in \
      --replace '$'"{prefix}/@CMAKE_INSTALL_INCLUDEDIR@" '@CMAKE_INSTALL_FULL_INCLUDEDIR@'
  '';

  nativeBuildInputs = [ cmake ];

  passthru.tests.pkg-config = testers.hasPkgConfigModules { package = finalAttrs.finalPackage; };

<<<<<<< HEAD
  meta = {
    description = "Clever Audio Plugin API interface headers";
    homepage = "https://cleveraudio.org/";
    pkgConfigModules = [ "clap" ];
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ris ];
=======
  meta = with lib; {
    description = "Clever Audio Plugin API interface headers";
    homepage = "https://cleveraudio.org/";
    pkgConfigModules = [ "clap" ];
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ ris ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
