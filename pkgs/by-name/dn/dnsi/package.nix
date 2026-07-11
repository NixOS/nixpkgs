{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dnsi";
  version = "0.2.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = "dnsi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HWYn3IHUoH3248ZGCU9JKO3BALZqxiaNX1Q2+bHjw0A=";
  };

  nativeBuildInputs = [ installShellFiles ];

  cargoHash = "sha256-uIW7EDL2ulg6qDizjw5iHtc5HqyEZDBoXJxWHZOmoqo=";

  postInstall = ''
    installManPage doc/*.1
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line tool to investigate the Domain Name System";
    mainProgram = "dnsi";
    homepage = "https://nlnetlabs.nl/projects/domain/dnsi/";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.skyesoss ];
  };
})
