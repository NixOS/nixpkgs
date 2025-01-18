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
  version = "20220606.eb585f8";

  src = fetchurl {
    url = "https://www.chiark.greenend.org.uk/~sgtatham/spigot/spigot-${finalAttrs.version}.tar.gz";
    hash = "sha256-JyNNZo/HUPWv5rYtlNYp8Hl0C7i3yxEyKm+77ysN7Ao=";
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

  meta = with lib; {
    homepage = "https://www.chiark.greenend.org.uk/~sgtatham/spigot/";
    description = "Command-line exact real calculator";
    mainProgram = "spigot";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
})
