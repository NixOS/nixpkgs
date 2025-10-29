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
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "richgel999";
    repo = "miniz";
    rev = finalAttrs.version;
    hash = "sha256-DQbXz1ehBNGFhuaW5Nz509njpPe73QpMHyKDbpqX0aI=";
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
