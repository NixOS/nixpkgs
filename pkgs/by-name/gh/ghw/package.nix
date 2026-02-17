{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "ghw";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "jaypipes";
    repo = "ghw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W3a6hKX8vsWe02uLUx9zIOmJiivIOa4Ja++iXVd8J3E=";
  };
  vendorHash = "sha256-REgtByhTlYQ3XyYleWAcrCymIWtWmltjx21tr2mtF7k=";

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
