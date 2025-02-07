{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "hacompanion";
  version = "1.0.21";

  src = fetchFromGitHub {
    owner = "tobias-kuendig";
    repo = "hacompanion";
    rev = "v${version}";
    hash = "sha256-6fj9Gs/ezISx5Llele5mrTFR0IiQzzm1wWcAywTaFPk=";
  };

  vendorHash = "sha256-y2eSuMCDZTGdCs70zYdA8NKbuPPN5xmnRfMNK+AE/q8=";

  meta = {
    changelog = "https://github.com/tobias-kuendig/hacompanion/releases/tag/v${version}";
    description = "Daemon that sends local hardware information to Home Assistant";
    homepage = "https://github.com/tobias-kuendig/hacompanion";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ramblurr ];
  };
}
