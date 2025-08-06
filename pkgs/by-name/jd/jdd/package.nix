{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "jdd";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "mahyarmirrashed";
    repo = "jdd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JeF6dsExfQ+d5F8RWmfGbr7CIl6akOTlLI2jxx/dES0=";
  };

  vendorHash = "sha256-KEg5X2wHx7KPHEL1zJd/DeDnR69FyB6pajpHIYdep2k=";

  ldflags = [ "-X=main.version=${finalAttrs.version}" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "Johnny Decimal daemon for automatically organizing files into the correct drawer using their filename";
    homepage = "https://github.com/mahyarmirrashed/jdd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mahyarmirrashed ];
    mainProgram = "jdd";
  };
})
