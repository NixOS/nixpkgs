{
  lib,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rmux";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "Helvesec";
    repo = "rmux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W+H5MBh+EPkppdDaHMTPUVM1ZpPca/MeVOs/GM1x8UQ=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-kGZczNoHKHWR4fpAvXRhldpYHVgSkIOgAa/OUSaZVvs=";

  nativeBuildInputs = [ installShellFiles ];

  passthru.updateScript = nix-update-script { };

  # Tests require network access
  doCheck = false;

  meta = {
    description = "Universal multiplexer with a typed SDK";
    homepage = "https://github.com/Helvesec/rmux";
    changelog = "https://github.com/Helvesec/rmux/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "rmux";
  };
})
