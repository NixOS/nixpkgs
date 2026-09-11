{
  buildGoModule,
  fetchFromGitHub,
  lib,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "gostatic";
  version = "2.36";

  src = fetchFromGitHub {
    owner = "sansolovyov";
    repo = "gostatic";
    tag = finalAttrs.version;
    hash = "sha256-5ytySvev1oyLeLJ/d+z/ZV0Ejr6pAvsORXKkrSmAQbw=";
  };

  vendorHash = "sha256-+Kv33MCzyzNVBokYz6A8Wa5nyMCnwSAYqy5o+4sMNWQ=";

  # go.mod declares "go 1.16", but the vendored golang.org/x/sys needs unsafe.Slice (Go 1.17)
  preBuild = ''
    substituteInPlace go.mod --replace-fail "go 1.16" "go 1.17"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Fast static site generator";
    homepage = "https://github.com/sansolovyov/gostatic";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ kamadorueda ];
    mainProgram = "gostatic";
  };
})
