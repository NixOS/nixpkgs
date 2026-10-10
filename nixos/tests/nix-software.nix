{ lib, ... }:

{
  name = "nix-software";
  meta.maintainers = with lib.maintainers; [ SPTApyo ];

  nodes.machine.programs.nix-software.enable = true;

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.succeed("nix-software-cli --version | grep -q 'nix-software'")
    machine.succeed("test -e /run/current-system/sw/share/applications/io.github.sptapyo.NixSoftware.desktop")
    machine.succeed("test -e /run/current-system/sw/share/gnome-shell/search-providers/io.github.sptapyo.NixSoftware.search-provider.ini")
  '';
}
