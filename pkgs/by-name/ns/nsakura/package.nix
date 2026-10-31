{
  lib,
  buildNimPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNimPackage (finalAttrs: {
  pname = "nsakura";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "KornelHajto";
    repo = "nsakura";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/PAcHS0Yxhwp76FlyQXvBmlcSvaOsLtBEbgAKmmASIg=";
  };

  #lockFile = ./lock.json;

  passthru.updatescript = nix-update-script { };

  nimFlags = [ "-d:NimblePkgVersion=${finalAttrs.version}" ];

  meta = {
    description = "Tui that generates a cherry blossom for screensaver";
    homepage = "https://github.com/KornelHajto/nsakura";
    changelog = "https://github.com/KornelHajto/nsakura/commits/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eveeifyeve ];
  };
})
