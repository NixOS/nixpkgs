{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cpc";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "kasper9n";
    repo = "cpc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-reaKxnWGg3lIUFjCRwaX4HMb+f8371OFKffpBWR48w0=";
  };

  cargoHash = "sha256-DlxJolTdEqeoczIY0utECw1Xjn0LlyMBo6vLwCYhTjA=";

  meta = {
    mainProgram = "cpc";
    description = "Text calculator with support for units and conversion";
    homepage = "https://github.com/kasper9n/cpc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      s0me1newithhand7s
    ];
  };
})
