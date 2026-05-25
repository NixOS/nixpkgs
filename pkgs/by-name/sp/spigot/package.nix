{
  lib,
  stdenv,
  fetchurl,
  callPackage,
  cmake,
  gmp,
  halibut,
  ncurses,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spigot";
  version = "20240909.f158e08";

  src = fetchurl {
    url = "https://www.chiark.greenend.org.uk/~sgtatham/spigot/spigot-${finalAttrs.version}.tar.gz";
    hash = "sha256-8re4ubDgsTjc/WrE60b6eXBrGEJSKJTEXd/XMdJ79nM=";
  };

  nativeBuildInputs = [
    cmake
    halibut
    perl
  ];

  buildInputs = [
    gmp
    ncurses
  ];

  outputs = [
    "out"
    "man"
  ];

  strictDeps = true;

  passthru.tests = {
    approximation = callPackage ./tests/approximation.nix {
      spigot = finalAttrs.finalPackage;
    };
  };

  meta = {
    homepage = "https://www.chiark.greenend.org.uk/~sgtatham/spigot/";
    description = "Command-line exact real calculator";
    mainProgram = "spigot";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
