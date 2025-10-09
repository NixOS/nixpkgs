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
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "TD-Sky";
    repo = "conceal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B6vZ4Xl7H6KOlscys+FT8fMXb0Xrvosr2DXHzvRjLis=";
  };

  cargoHash = "sha256-aBc9ijRObFi9AyQxSoQZs/3exAzOlYq5uNqFfvjNhvw=";

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
