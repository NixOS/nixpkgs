{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  efivar,
  nix-update-script,
  pkg-config,
  popt,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "efibootmgr";
  version = "18";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "rhboot";
    repo = "efibootmgr";
    tag = finalAttrs.version;
    hash = "sha256-DYYQGALEn2+mRHgqCJsA7OQCF7xirIgQlWexZ9uoKcg=";
  };

  patches = [
    (fetchpatch2 {
      # https://github.com/rhboot/efibootmgr/issues/186
      name = "efibootmgr_fix-editing-nonfinal-entry.patch";
      url = "https://github.com/rhboot/efibootmgr/commit/3eac27c5fccf93d2d6e634d6fe2a76d06708ec6e.diff?full_index=1";
      hash = "sha256-zXkmfW+BYv8jc/dibu0LEni06KyydVjfW/Lug0i+jUw=";
    })
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    efivar
    popt
  ];

  makeFlags = [
    "EFIDIR=nixos"
    "PKG_CONFIG=${stdenv.cc.targetPrefix}pkg-config"
  ];

  installFlags = [ "prefix=${placeholder "out"}" ];

  passthru = {
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Linux user-space application to modify the Intel Extensible Firmware Interface (EFI) Boot Manager";
    homepage = "https://github.com/rhboot/efibootmgr";
    changelog = "https://github.com/rhboot/efibootmgr/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "efibootmgr";
    platforms = lib.platforms.linux;
  };
})
