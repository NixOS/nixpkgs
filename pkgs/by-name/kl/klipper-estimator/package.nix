{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  libgit2,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "klipper-estimator";
  version = "3.7.3";

  # FIXME: The project is archived, maybe switch to a fork?
  src = fetchFromGitHub {
    owner = "Annex-Engineering";
    repo = "klipper_estimator";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EjfW2qeq0ehGhjE2Psz5g/suYMZPvtQi2gaYb+NCa2U=";
  };

  cargoPatches = [
    ./update-git2.patch
  ];

  cargoHash = "sha256-abiSSuwg/BYwMIN0mF9D9whCnpsVYnI4qOHBkVir2kg=";

  env.TOOL_VERSION = "v${finalAttrs.version}";

  buildInputs = [
    openssl
    libgit2
  ];

  nativeBuildInputs = [ pkg-config ];

  # libgit2-sys 0.16 needs libgit2 1.7, nixpkgs has 1.9: use the bundled copy
  preBuild = ''
    export LIBGIT2_NO_VENDOR=0
  '';

  meta = {
    description = "Tool for determining the time a print will take using the Klipper firmware";
    homepage = "https://github.com/Annex-Engineering/klipper_estimator";
    changelog = "https://github.com/Annex-Engineering/klipper_estimator/releases/tag/v${finalAttrs.version}";
    mainProgram = "klipper_estimator";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tmarkus ];
  };
})
