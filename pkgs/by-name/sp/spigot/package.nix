{ lib
, stdenv
, fetchurl
, callPackage
, cmake
, gmp
, halibut
, ncurses
, perl
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

  outputs = [ "out" "man" ];

  strictDeps = true;

  passthru.tests = {
    approximation = callPackage ./tests/approximation.nix {
      spigot = finalAttrs.finalPackage;
    };
  };

  meta = {
    homepage = "https://www.chiark.greenend.org.uk/~sgtatham/spigot/";
    description = "A command-line exact real calculator";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
