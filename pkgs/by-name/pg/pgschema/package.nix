{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  postgresql,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "pgschema";
  version = "1.12.5";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pgplex";
    repo = "pgschema";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mT/cdpWPUb6znNRQ3QSl/8U+ZmNcYvidCZTsbIMnn0Y=";
  };

  # Adapted from $src/nix/pgschema.nix
  proxyVendor = true;
  vendorHash = "sha256-tHz0R2NWxoecWKML8Q71Z0LZDM9DHH+bTHO3K+ekNG8=";

  env.CGO_ENABLED = "0";
  ldflags = [
    "-s"
    "-w"
    "-X"
    "github.com/pgplex/pgschema/cmd.GitCommit=${finalAttrs.src.rev}"
    "-X"
    "github.com/pgplex/pgschema/internal/postgres.binariesPath=${postgresql}"
  ];

  # Tests fail in sandbox on darwin, with:
  # Could not create shared memory segment: Cannot allocate memory
  # Failed system call was shmget(key=18446744072262306125, size=56, 03600)
  doCheck = !stdenv.hostPlatform.isDarwin;

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

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
