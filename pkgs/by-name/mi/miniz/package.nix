{
  lib,
  fetchFromGitHub,
  nix-update-script,
  stdenv,
  testers,
  validatePkgConfig,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "miniz";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "richgel999";
    repo = "miniz";
    rev = finalAttrs.version;
    hash = "sha256-3J0bkr2Yk+MJXilUqOCHsWzuykySv5B1nepmucvA4hg=";
  };
  passthru.updateScript = nix-update-script { };

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    validatePkgConfig
  ];

  postFixup = ''
    substituteInPlace "$out"/lib/pkgconfig/miniz.pc \
      --replace-fail '=''${prefix}//' '=/' \
      --replace-fail '=''${exec_prefix}//' '=/'
  '';

  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
    versionCheck = true;
  };

  meta = with lib; {
    description = "Single C source file zlib-replacement library";
    homepage = "https://github.com/richgel999/miniz";
    license = licenses.mit;
    maintainers = with maintainers; [ astro ];
    platforms = platforms.unix;
    pkgConfigModules = [ "miniz" ];
  };
})
