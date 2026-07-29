{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
  installShellFiles,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "ralphex";
  version = "1.6.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "umputun";
    repo = "ralphex";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M1VeZgpNv64ZbcNvhzscnhTJhuR6yrh+clAWAce7vxI=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X main.revision=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [
    git
    writableTmpDirAsHomeHook
  ];

  __darwinAllowLocalNetworking = true;

  postInstall = ''
    installShellCompletion completions/*
  '';

  meta = {
    description = "Extended Ralph loop for autonomous AI-driven plan execution";
    homepage = "https://ralphex.com/";
    license = lib.licenses.mit;
    mainProgram = "ralphex";
    maintainers = [ lib.maintainers.sikmir ];
  };
})
