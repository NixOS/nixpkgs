{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "forgelink";
  version = "0.3.7";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dpassen";
    repo = "forgelink";
    rev = "89696a285a722a8277b5dc89663b4c23da4c6c0b";
    hash = "sha256-OBgx091pQm6wjUkXzrzcdSj82ykyL4jAQCXh+CbHxyA=";
  };

  cargoHash = "sha256-3MfwzqFE3+LKrsonLOa8TbgY47mC6Fsarnf8naKGOis=";

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
