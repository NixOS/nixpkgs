{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jf";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "sayanarijit";
    repo = "jf";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GKAOM+YQicpPlCiecl4EgVDdvlHXP8j5txCodZVUKRg=";
  };

  cargoHash = "sha256-6fs3fhm0l24EZNZm3xXw8Uxb1Ot3pw+myfSJzWG3alU=";

  nativeBuildInputs = [ installShellFiles ];

  # skip auto manpage update
  buildNoDefaultFeatures = true;

  postInstall = ''
    installManPage assets/jf.1
  '';

  meta = {
    description = "Small utility to safely format and print JSON objects in the commandline";
    mainProgram = "jf";
    homepage = "https://github.com/sayanarijit/jf";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sayanarijit ];
  };
})
