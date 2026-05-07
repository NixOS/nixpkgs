{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "base16-universal-manager";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "pinpox";
    repo = "base16-universal-manager";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9KflJ863j0VeOyu6j6O28VafetRrM8FW818qCvqhaoY=";
  };

  vendorHash = "sha256-U28OJ5heeiaj3aGAhR6eAXzfvFMehAUcHzyFkZBRK6c=";

  meta = {
    description = "Universal manager to set base16 themes for any supported application";
    homepage = "https://github.com/pinpox/base16-universal-manager";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jo1gi ];
    mainProgram = "base16-universal-manager";
  };
})
