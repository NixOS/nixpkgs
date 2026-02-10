{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "smug";
  version = "0.3.14";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "ivaaaan";
    repo = "smug";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5MvDhG7cTbapF1mwEpuvEFvSpduwFnvv7seTh7Va5Yw=";
  };

  vendorHash = "sha256-N6btfKjhJ0MkXAL4enyNfnJk8vUeUDCRus5Fb7hNtug=";

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
