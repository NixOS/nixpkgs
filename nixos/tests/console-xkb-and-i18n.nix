{ lib, ... }:
{
  name = "console-xkb-and-i18n";
  meta.maintainers = with lib.maintainers; [ doronbehar ];

  nodes = {
    # Nothing to run on this node, a bug (TODO: where?) is causing a builder of
    # the configuration to fail. See:
    #
    # - https://github.com/NixOS/nixpkgs/issues/445666
    # - https://github.com/NixOS/nixpkgs/issues/411374
    #
    x = {
      i18n.defaultLocale = "eo";
      console.useXkbConfig = true;
      services.xserver.xkb = {
        layout = "us";
        variant = "colemak";
      };
    };
  };
  testScript = { nodes, ... }: "";
}
