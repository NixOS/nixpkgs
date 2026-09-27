{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nix-post-build-hook-queue";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "newAM";
    repo = "nix-post-build-hook-queue";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nD9x41meUh28JUdv0O0kBnXw1XtypINh1RRFMNorcqY=";
  };

  cargoHash = "sha256-Z1wGwvMJLAj6MP3RSX0D8ZAMq5iYEwkN9M9bJfZ+igk=";

  passthru.tests = {
    inherit (nixosTests) nix-post-build-hook-queue;
  };

  meta = {
    description = "Nix post-build-hook queue";
    homepage = "https://github.com/newAM/nix-post-build-hook-queue";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.newam ];
  };
})
