{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "ghw";
  version = "0.21.2";

  src = fetchFromGitHub {
    owner = "jaypipes";
    repo = "ghw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WZGEhrgHmJ/4puvDPYLq3iU+Ddf1PnptRj0ehcDbjZQ=";
  };
  vendorHash = "sha256-lItNgi65HQASNQufUdhvEoNtrltkW+0hBHUlFZjfneE=";

  subPackages = [ "cmd/..." ];
  doCheck = false; # wants to read from /sys and other places not allowed

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Go HardWare discovery/inspection library";
    mainProgram = "ghwc";
    homepage = "https://github.com/jaypipes/ghw";
    maintainers = [ lib.maintainers.mmlb ];
    license = lib.licenses.asl20;
  };
})
