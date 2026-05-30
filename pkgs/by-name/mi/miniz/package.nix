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
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "richgel999";
    repo = "miniz";
    rev = finalAttrs.version;
    hash = "sha256-hRB/0TVVQjr4VwjozfRnYKUJfeqO+1PNfdvP/rrOCR4=";
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

  meta = {
    description = "Single C source file zlib-replacement library";
    homepage = "https://github.com/richgel999/miniz";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ astro ];
    platforms = lib.platforms.unix;
    pkgConfigModules = [ "miniz" ];
  };
})
