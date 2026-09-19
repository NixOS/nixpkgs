{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "ryelang";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "refaktor";
    repo = "rye";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6H5PsgORZmSlMDkjqeN/DOhRL/dUWCZ5+kCkVnR6nXA=";
  };

  vendorHash = "sha256-Jy0250Iv3eif3JMiyjdFv+uInEV5Z2HpOi6hL2/kgKI=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X"
    "github.com/refaktor/rye/runner.Version=${finalAttrs.version}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "High-level, dynamic programming language inspired by Rebol, Factor, Linux shells, and Go";
    homepage = "https://ryelang.org/";
    changelog = "https://github.com/refaktor/rye/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ amadejkastelic ];
    mainProgram = "rye";
  };
})
