{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  testers,

  # for passthru.tests
  gtk3,
  gtk4,
  sassc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libsass";
  version = "3.6.6"; # also check sassc for updates

  src = fetchFromGitHub {
    owner = "sass";
    repo = "libsass";
    rev = finalAttrs.version;
    hash = "sha256-FkLL3OAJXDptRQY6ZkYbss2pcc40f/wasIvEIyHRQFo=";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    postFetch = ''
      rm -r $out/test/e2e/unicode-pwd
    '';
  };

  preConfigure = ''
    export LIBSASS_VERSION=${finalAttrs.version}
  '';

  nativeBuildInputs = [ autoreconfHook ];

  enableParallelBuilding = true;

  passthru.tests = {
    inherit gtk3 gtk4 sassc;
    pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

<<<<<<< HEAD
  meta = {
    description = "C/C++ implementation of a Sass compiler";
    homepage = "https://github.com/sass/libsass";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "C/C++ implementation of a Sass compiler";
    homepage = "https://github.com/sass/libsass";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      codyopel
      offline
    ];
    pkgConfigModules = [ "libsass" ];
<<<<<<< HEAD
    platforms = lib.platforms.unix;
=======
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
