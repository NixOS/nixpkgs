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
  version = "0.52.0";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "atmosphere";
    tag = finalAttrs.version;
    hash = "sha256-A0rGFN0Uen4d1vPNKnbWsK/zsSN2HUN81p7cuEbHQQs=";
  };

  cargoHash = "sha256-31OtWRIMG2yY20v/m1LnJJINH1k1Q6vTnlolMCFS/sY=";

  postInstall = ''
    mkdir -p $out/share/atmosphere
    cp -r default_envs $out/share/atmosphere
  '';

  __structuredAttrs = true;

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
