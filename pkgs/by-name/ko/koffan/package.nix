{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "koffan";
  version = "2.12.3";

  src = fetchFromGitHub {
    owner = "PanSalut";
    repo = "Koffan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mApQftAsoXh6CTFRPu28O9iK5Ow2/QwkAx4V8XPWTvg=";
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
