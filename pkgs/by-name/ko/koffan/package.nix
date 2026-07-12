{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "koffan";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "PanSalut";
    repo = "Koffan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E4R2FrL6pqwz1yuF+0TuSIE33/ksrvE0U9XO4z11AfE=";
  };

  vendorHash = "sha256-BYehi5LQQ0MIsKG/fN3DHaQwKVmxUFrvWGrKZeKj+ow=";

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
