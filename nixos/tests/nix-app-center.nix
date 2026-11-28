{ lib, ... }:

{
  name = "nix-app-center";
  meta.maintainers = with lib.maintainers; [ SPTApyo ];

  nodes.machine.programs.nix-app-center.enable = true;

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.succeed("nix-app-center-cli --version | grep -q 'nix-app-center'")
    machine.succeed("test -e /run/current-system/sw/share/applications/io.github.sptapyo.NixAppCenter.desktop")
    machine.succeed("test -e /run/current-system/sw/share/gnome-shell/search-providers/io.github.sptapyo.NixAppCenter.search-provider.ini")
  '';
}
