{
  lib,
  fetchFromGitea,
  nftables,
  nixosTests,
  pkg-config,
  rustPlatform,
  ...
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "iocaine";
  version = "3.5.1";

  src = fetchFromGitea {
    domain = "git.madhouse-project.org";
    owner = "iocaine";
    repo = "iocaine";
    tag = "iocaine-${finalAttrs.version}";
    hash = "sha256-FkIgrptTiYZwHBa6blFeB4HrgTpMREbW004hKpcAKx0=";
  };

  cargoHash = "sha256-GHveoZ19VaQie9D9i+yoKevB/cnxKd7GLnNOZcAqtJ0=";

  __structuredAttrs = true;

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    nftables
  ];

  passthru = {
    tests = { inherit (nixosTests) iocaine; };
  };

  meta = {
    description = "Deadliest poison known to AI";
    homepage = "https://iocaine.madhouse-project.org/";
    changelog = "https://git.madhouse-project.org/iocaine/iocaine/src/tag/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ sugar700 ];
    mainProgram = "iocaine";
  };
})
