{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "rawst";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "Jupiee";
    repo = "rawst";
    tag = "${finalAttrs.version}";
    hash = "sha256-+uhE80XoZyMBV+nmlP+C5DfoB+z4tyK69XGsuALxROs=";
  };

  cargoHash = "sha256-wS1dR6r3/4sg4DCMR8QZjbHgiSEhuu/v4MqJ6LxEKtY=";
  env.RUSTC_BOOTSTRAP = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cli downloader, written in rust";
    homepage = "https://github.com/Jupiee/rawst";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ Inarizxc ];
    platforms = lib.platforms.linux;
    mainProgram = "rawst";
  };
})
