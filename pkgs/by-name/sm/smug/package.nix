{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "smug";
  version = "0.3.18";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "ivaaaan";
    repo = "smug";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+A+FKHmJcStoumw/aDeSHG8nZ8hJbiizViC1MpbzT7g=";
  };

  vendorHash = "sha256-0PWAY2CeBtaRqkN93ZWeVSynaMW8E9zJwUxI5CzC1mE=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  postInstall = ''
    installManPage ./man/man1/smug.1
    installShellCompletion completion/smug.{bash,fish}
  '';

  meta = {
    homepage = "https://github.com/ivaaaan/smug";
    description = "tmux session manager";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ juboba ];
    mainProgram = "smug";
  };
})
