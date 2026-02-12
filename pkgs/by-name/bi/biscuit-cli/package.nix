{
  lib,
  fetchFromGitHub,
  rustPlatform,
  testers,
  nix-update-script,
  biscuit-cli,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "biscuit-cli";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "biscuit-auth";
    repo = "biscuit-cli";
    tag = finalAttrs.version;
    sha256 = "sha256-s4Y4MhM79Z+4VxB03+56OqRQJaSHj2VQEJcL6CsT+2k=";
  };

  cargoHash = "sha256-OG8/9CxOTCYXwyavdaXvak8GbCOMvelcsSJVkEgdMdI=";

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      inherit (finalAttrs) version;
      package = biscuit-cli;
      command = "biscuit --version";
    };
  };

  meta = {
    description = "CLI to generate and inspect biscuit tokens";
    homepage = "https://www.biscuitsec.org/";
    maintainers = with lib.maintainers; [ shlevy ];
    license = lib.licenses.bsd3;
    mainProgram = "biscuit";
  };
})
