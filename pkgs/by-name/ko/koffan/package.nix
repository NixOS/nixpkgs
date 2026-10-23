{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "koffan";
  version = "2.17.0";

  src = fetchFromGitHub {
    owner = "PanSalut";
    repo = "Koffan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9+SrTmWQMcTHTjmsLDQ4F1grRwX7I3IIw4mhyph2kqE=";
  };

  vendorHash = "sha256-Phs9xPBfCbkMAXHTJNHy4F7xRGxrWNmJ9h9SfczoCNQ=";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Free selfhosted groceries list for families and shared households";
    mainProgram = "shopping-list";
    homepage = "https://github.com/PanSalut/Koffan";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lykos153 ];
  };
})
