{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  openssl,
  perl,
  pkg-config,
  stdenv,
  vimUtils,
}:
let
<<<<<<< HEAD
  version = "e3f788f-unstable-2025-12-13";
  src = fetchFromGitHub {
    owner = "dmtrKovalenko";
    repo = "fff.nvim";
    rev = "e3f788f87b014f61e39cd916edc766d10e563d73";
    hash = "sha256-NSTo5zs9DvGDVUp6PJNHCQsSNPgdkJCTYvlA/IP12h4=";
=======
  version = "65aeacf-unstable-2025-11-03";
  src = fetchFromGitHub {
    owner = "dmtrKovalenko";
    repo = "fff.nvim";
    rev = "65aeacf9e2c663c9af2b1003727aa25acac96db4";
    hash = "sha256-rGfV/BxSwvcNZXmVUk54gni8fKFyoTsQl+gBtYci4jE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
  fff-nvim-lib = rustPlatform.buildRustPackage {
    pname = "fff-nvim-lib";
    inherit version src;

<<<<<<< HEAD
    cargoHash = "sha256-kNTJC+0KBQKt0nMY2HAUWnr55x8nTd5oRGeDuam8X30=";
=======
    cargoHash = "sha256-ZZt4BlMgRik4LH92F5cgS84WI1Jeuw68jP+y1+QXfDE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    nativeBuildInputs = [
      pkg-config
      perl
    ];

    buildInputs = [
      openssl
    ];

    env = {
      RUSTC_BOOTSTRAP = 1; # We need rust unstable features

      OPENSSL_NO_VENDOR = true;

      # Allow undefined symbols on Darwin - they will be provided by Neovim's LuaJIT runtime
      RUSTFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-C link-arg=-undefined -C link-arg=dynamic_lookup";
    };
  };
in
vimUtils.buildVimPlugin {
  pname = "fff.nvim";
  inherit version src;

  postPatch = ''
    substituteInPlace lua/fff/download.lua \
      --replace-fail \
        "return plugin_dir .. '/../target'" \
        "return '${fff-nvim-lib}/lib'"
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version=branch" ];
      attrPath = "vimPlugins.fff-nvim.fff-nvim-lib";
    };

    # needed for the update script
    inherit fff-nvim-lib;
  };

  meta = {
    description = "Fast Fuzzy File Finder for Neovim";
    homepage = "https://github.com/dmtrKovalenko/fff.nvim";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      GaetanLepage
    ];
  };
}
