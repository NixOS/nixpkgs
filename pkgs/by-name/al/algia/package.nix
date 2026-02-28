{
  pkgs,
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "algia";
  version = "0.0.105";

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "algia";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xjFhrMpk+j77qHYUPwP83fGraJtb08AMnFA84KkvaQc=";
  };

  vendorHash = "sha256-JTTWVs0KwceiLy6tpyd48zORiXLc18zwgG1c+ceivKU=";

  meta = {
    description = "CLI application for nostr";
    homepage = "https://github.com/mattn/algia";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ haruki7049 ];
    mainProgram = "algia";
  };
})
