{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  testers,

  sqlite,
  zstd,

  git,
  perl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "npb-unwrapped";
  version = "0-unstable-2026-07-27";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "samestep";
    repo = "npb";
    rev = "72ff3daa65418c74e953b26b7dd54e783961d721";
    hash = "sha256-c4AVr/JczA+Q6C0PUT/iLl6jg+/ksPvjxAIYZyCGSrM=";
  };

  cargoHash = "sha256-ZFxkuhHLhZVmW6HJW6uzOFwm/VTLADJ5O/W9V2z634A=";

  nativeBuildInputs = [
    perl
    pkg-config
  ];

  nativeCheckInputs = [ git ];

  buildInputs = [
    sqlite
    zstd
  ];

  env = {
    LIBSQLITE3_SYS_USE_PKG_CONFIG = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
    NPB_REV =
      if finalAttrs.src.tag != null then
        finalAttrs.src.tag
      else if finalAttrs.src.rev != null then
        finalAttrs.src.rev
      else
        "main";
  };

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      version = "https://github.com/samestep/npb/tree/${finalAttrs.env.NPB_REV}";
    };
  };

  meta = {
    description = "Nixpkgs build outcome diff CLI";
    homepage = "https://github.com/samestep/npb";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      samestep
      dtomvan
    ];
    mainProgram = "npb";
  };
})
