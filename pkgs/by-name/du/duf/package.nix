{
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "duf";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "muesli";
    repo = "duf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d/co7EaDk0m/oYxWFATxQYCdH3Z9r8eTtOOo+M+HD4o=";
  };

  vendorHash = "sha256-Br2jagMynnzH77GNA7NeWbM5qSHbhfW5Bo7X2b6OX28=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage duf.1
  '';

  meta = {
    homepage = "https://github.com/muesli/duf/";
    description = "Disk Usage/Free Utility";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmasquadron ];
    mainProgram = "duf";
  };
})
