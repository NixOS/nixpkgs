{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "forgelink";
  version = "0-unstable-2026-06-23";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dpassen";
    repo = "forgelink";
    rev = "5d556f07786496c299fb85a0ea35d8af05fa8ac4";
    hash = "sha256-PDSRg6j/kINLu5KLBsaPXIK+2cNAJFn3iMSilLzVq+c=";
  };

  cargoHash = "sha256-SilcKwzrxulduHpP1jH6SWDmVyDTfuni//FZxLqIKco=";

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
