{
  fetchFromGitHub,
  git,
  jujutsu,
  lean4,
  lib,
  nix-update-script,
  openssh,
  pkg-config,
  rustPlatform,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jj-musubi";
  version = "0.47.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bos";
    repo = "jj-musubi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hiQDJf6/08SDCNxs+vN7zC/EF+te/vf2Swi0HP7mfaY=";
  };

  cargoHash = "sha256-gliTi21j3XqIMc7udbnMnU1JNu7SU9DsepeePG3jBXI=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    zstd
  ];

  nativeCheckInputs = [
    git
    jujutsu
    lean4
    openssh
  ];

  checkFlags = [
    # The fake sudo script uses /bin/rm and other FHS paths unavailable in the sandbox,
    # so cleanup fails and leaves the installation marker behind.
    "--skip=login::process_tests::service_installation_tracks_success_and_keeps_services_separate"
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  postPatch = ''
    patchShebangs contrib/upgrade-from-source
  '';

  doCheck = false;
  preCheck = ''
    cd formal
    lake build oracle
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Keep jj repos in sync across your machines, live";
    homepage = "https://github.com/bos/jj-musubi";
    changelog = "https://github.com/bos/jj-musubi/blob/v${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bbigras ];
    mainProgram = "jj-musubi";
  };
})
