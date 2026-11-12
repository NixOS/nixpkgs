{
  fetchFromGitHub,
  lib,
  nixosTests,
  rustPlatform,
  openssl,
  pkg-config,
  unstableGitUpdater,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "agnos";
  version = "0.1.1-unstable-2026-11-06";

  src = fetchFromGitHub {
    owner = "krtab";
    repo = "agnos";
    rev = "6bcbc16cd5be18e8c80b86a77bbf8840795774c1";
    hash = "sha256-hHy+jfZzQGV56fWNQAfqtwUI6ina8mW/u6Ln6Wm//iY=";
  };

  cargoHash = "sha256-yGeE36oeCF2TxVQt+2xU1Kb9ux4yMiGFJdeiRbYN6kI=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  meta = {
    description = "Obtains certificates from Let's Encrypt using DNS-01 without the need for API access to the DNS provider";
    homepage = "https://github.com/krtab/agnos";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ justinas ];
  };

  passthru = {
    tests = nixosTests.agnos;
    updateScript = unstableGitUpdater { tagPrefix = "v"; };
  };
})
