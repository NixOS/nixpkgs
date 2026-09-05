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
  version = "3.5.0";

  src = fetchFromGitea {
    domain = "git.madhouse-project.org";
    owner = "iocaine";
    repo = "iocaine";
    tag = "iocaine-${finalAttrs.version}";
    hash = "sha256-adsQuSL4F1mfSsUtLwdgUtHVYessBM31tlBU8Rbbst4=";
  };

  cargoHash = "sha256-rGPT0YKQ+p11V4+EOMVZrvEmF1Ylbg0hFpSao+Hqn/4=";

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
