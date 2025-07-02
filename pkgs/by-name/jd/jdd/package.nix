{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "jdd";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "mahyarmirrashed";
    repo = "jdd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uyccIqQL3uZaq0t/tEZbSf67Hr6KxcGCljE33GTs/fI=";
  };

  vendorHash = "sha256-MBj2z+C9wMPhLMf5pA8RCycLK+cqsaGlYF8t7rGk+jU=";

  subPackages = [ "cmd/daemon" ];

  ldflags = [ "-X=main.version=${finalAttrs.version}" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  postInstall = ''
    install -Dm755 $out/bin/daemon $out/bin/jdd
  '';

  meta = {
    description = "Johnny Decimal daemon for automatically organizing files into the correct drawer using their filename";
    homepage = "https://github.com/mahyarmirrashed/jdd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mahyarmirrashed ];
    mainProgram = "jdd";
  };
})
