{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  postgresql,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "pgschema";
  version = "1.12.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pgplex";
    repo = "pgschema";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zfG87Uc5bx14zhYnuT3CF+sW5EEQLBRRMyBe57FBHJ4=";
  };

  # Adapted from $src/nix/pgschema.nix
  proxyVendor = true;
  vendorHash = "sha256-3nV7AEsWyEvIbxHetoEsA8PPXJ6ENvU/sz7Wn5aysss=";

  env.CGO_ENABLED = "0";
  ldflags = [
    "-s"
    "-w"
    "-X"
    "github.com/pgplex/pgschema/cmd.GitCommit=${finalAttrs.src.rev}"
    "-X"
    "github.com/pgplex/pgschema/internal/postgres.binariesPath=${postgresql}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--help"; # there is no -v/--version

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terraform-style, declarative Postgres schema migration";
    homepage = "https://github.com/pgplex/pgschema";
    changelog = "https://github.com/pgplex/pgschema/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.bengsparks ];
    mainProgram = "pgschema";
    platforms = lib.platforms.unix;
  };
})
