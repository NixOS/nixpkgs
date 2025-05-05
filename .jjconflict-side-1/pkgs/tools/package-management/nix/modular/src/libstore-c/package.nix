{
  lib,
  mkMesonLibrary,

  nix-util-c,
  nix-store,

  # Configuration Options

  version,
}:

mkMesonLibrary (finalAttrs: {
  pname = "nix-store-c";
  inherit version;

  workDir = ./.;

  propagatedBuildInputs = [
    nix-util-c
    nix-store
  ];

  mesonFlags = [
  ];

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };

})
