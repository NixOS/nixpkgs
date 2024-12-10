{ lib, ... }:
{
  imports = [
    (lib.mkRemovedOptionModule [ "services" "github-runner" ] "Use `services.github-runners.*` instead")
    ./github-runner/options.nix
    ./github-runner/service.nix
  ];

  meta.maintainers = with lib.maintainers; [
    veehaitch
    newam
  ];
}
