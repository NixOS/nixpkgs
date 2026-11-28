{
  lib,
  fetchFromGitea,
  nftables,
  zstd,
  nixosTests,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "iocaine";
  version = "3.6.0";

  src = fetchFromGitea {
    domain = "git.madhouse-project.org";
    owner = "iocaine";
    repo = "iocaine";
    tag = "iocaine-${finalAttrs.version}";
    hash = "sha256-3tjk6yKeWS2dP0mFkIL3NbxiNkiGMY41IQA+x0ZHxW4=";
  };

  cargoHash = "sha256-YGQ+y/LSkd2O5AodqWZeMiVLEz0ymDqTJOEyaLvgG+M=";

  __structuredAttrs = true;

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    nftables
    zstd
  ];

  passthru = {
    tests = { inherit (nixosTests) iocaine; };
  };

  meta = {
    description = "Deadliest poison known to AI";
    homepage = "https://iocaine.madhouse-project.org/";
    changelog = "https://git.madhouse-project.org/iocaine/iocaine/src/tag/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    platforms = lib.platforms.linux;
    mainProgram = "iocaine";
  };
})
