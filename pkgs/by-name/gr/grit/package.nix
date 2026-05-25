{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "grit";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "climech";
    repo = "grit";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-c8wBwmXFjpst6UxL5zmTxMR4bhzpHYljQHiJFKiNDms=";
  };

  vendorHash = "sha256-iMMkjJ5dnlr0oSCifBQPWkInQBCp1bh23s+BcKzDNCg=";

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Multitree-based personal task manager";
    homepage = "https://github.com/climech/grit";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "grit";
  };
})
