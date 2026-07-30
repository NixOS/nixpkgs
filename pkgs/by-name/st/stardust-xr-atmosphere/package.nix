{
  lib,
  fetchFromGitHub,
  rustPlatform,
  testers,
  stardust-xr-atmosphere,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stardust-xr-atmosphere";
  version = "0.51.1";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "atmosphere";
    tag = finalAttrs.version;
    hash = "sha256-FH9Y+p17bGczRhLEfxVqc1peg9Aubw1pu7QOYb6RWvc=";
  };

  cargoHash = "sha256-TVAm6BdIAE+gxWkpEUqF3R99UKhIGGSZK9qQ7urR7Uc=";

  postInstall = ''
    mkdir -p $out/share/atmosphere
    cp -r default_envs $out/share/atmosphere
  '';

  __structuredAttrs = true;
  strictDeps = true;

  passthru = {
    tests.versionTest = testers.testVersion {
      package = stardust-xr-atmosphere;
      command = "atmosphere --version";
      version = "stardust-xr-atmosphere 0.4.0";
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Environment, homespace, and setup client for Stardust XR";
    homepage = "https://stardustxr.org";
    license = lib.licenses.mit;
    mainProgram = "atmosphere";
    teams = with lib.teams; [ stardust-xr ];
    platforms = lib.platforms.unix;
  };
})
