{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fq,
  installShellFiles,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "fq";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "wader";
    repo = "fq";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Prd0GkLQOdVtpjeu6Ga6dq3imOm7m4m1/kLp9g/1O0I=";
  };

  vendorHash = "sha256-oqS6j8YTllObGKR8rFvlcFaUGnT3uouOP7pfzuTcgGk=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = "installManPage doc/fq.1";

  passthru.tests = testers.testVersion { package = fq; };

  meta = {
    description = "jq for binary formats";
    mainProgram = "fq";
    homepage = "https://github.com/wader/fq";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siraben ];
  };
})
