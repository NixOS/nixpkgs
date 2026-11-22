{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  expat,
  icu,
  inih,
  pkg-config,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "liblcf";
  version = "0.8.1";

  # nixpkgs-update: no auto update
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "EasyRPG";
    repo = "liblcf";
    tag = finalAttrs.version;
    hash = "sha256-jIk55+n8wSk3Z3FPR18SE7U3OuWwmp2zJgvSZQBB2l0=";
  };

  outputs = [
    "out"
    "bin"
    "dev"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  propagatedBuildInputs = [
    expat
    icu
    inih
  ];

  postPatch = ''
    substituteInPlace configure.ac \
      --replace-fail "[icu-i18n]" "[icu-i18n icu-uc]"
  '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  enableParallelBuilding = true;
  enableParallelChecking = true;
  passthru.tests.pkg-config = testers.hasPkgConfigModules { package = finalAttrs.finalPackage; };

  meta = {
    description = "Library to handle RPG Maker 2000/2003 and EasyRPG projects";
    homepage = "https://github.com/EasyRPG/liblcf";
    changelog = "https://github.com/EasyRPG/liblcf/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = lib.platforms.all;
    pkgConfigModules = [ "liblcf" ];
  };
})
