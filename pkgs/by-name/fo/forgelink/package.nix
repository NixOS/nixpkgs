{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "forgelink";
  version = "0.3.12";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dpassen";
    repo = "forgelink";
    rev = "3470588d92d3b4d175d9fc8cf5f9a5106ee885ca";
    hash = "sha256-PFH7ie0TmXXhZm4zfgXZ43PHUqpJsbDSVOk/HBNyt4k=";
  };

  cargoHash = "sha256-mU7fBheJNojA2Tcs7cA/lc7FwkYg6J9RChs7hYl3p0I=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for generating shareable URLs to files in hosted git repositories";
    homepage = "https://github.com/dpassen/forgelink";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "forgelink";
  };
})
