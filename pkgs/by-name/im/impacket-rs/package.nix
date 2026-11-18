{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "impacket-rs";
  version = "0.5.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "nestho";
    repo = "impacket-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SBRE5DHQzd0cIkNQeikDnh8YE8eTkaoX0tJ/z1rVJRg=";
  };

  cargoHash = "sha256-xAyh8aOxS/GrEDbsNqf3maEUAhIFZ+BQ8q7xnwg6oNI=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Impacket protocols and Active Directory tools";
    homepage = "https://github.com/nestho/impacket-rs";
    changelog = "https://github.com/nestho/impacket-rs/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "impacket-rs";
  };
})
