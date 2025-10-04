{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lacy";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "timothebot";
    repo = "lacy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xKzls9gC/RqkKNhzJMuPyG+59Qyf/BsydaqL5ovAtxE=";
  };

  passthru.updateScript = nix-update-script { };

  doCheck = false; # Remove in 0.3.1 once tests do not rely on folders

  cargoHash = "sha256-N5avoN3QCCYMF29Cvbwha+iBAXPncOttWxGpVZ70EqI=";

  meta = {
    description = "Fast magical cd alternative for lacy terminal navigators";
    homepage = "https://github.com/timothebot/lacy";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    mainProgram = "lacy";
    maintainers = with lib.maintainers; [ Srylax ];
  };
})
