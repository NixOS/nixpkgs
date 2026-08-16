{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  testers,
  conceal,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "conceal";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "TD-Sky";
    repo = "conceal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kPK00DjBHhyZVwCTuL3VSazS5pYY8lgLBn9bHTkaQ5s=";
  };

  cargoHash = "sha256-6MPYgReVYkEQhmifzT7sAMRuMIink8k9nWOnSUCOGG0=";

  env.CONCEAL_GEN_COMPLETIONS = "true";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion \
      completions/{cnc/cnc,conceal/conceal}.{bash,fish} \
      --zsh completions/{cnc/_cnc,conceal/_conceal}
  '';

  # There are not any tests in source project.
  doCheck = false;

  passthru.tests = testers.testVersion {
    package = conceal;
    command = "conceal --version";
    version = "conceal ${finalAttrs.version}";
  };

  meta = {
    description = "Trash collector written in Rust";
    homepage = "https://github.com/TD-Sky/conceal";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jedsek
      kashw2
    ];
    broken = stdenv.hostPlatform.isDarwin;
  };
})
