# Tests if opening a JCEF window with chrome://about by building
# and running a simple Java application using JBR.
{ lib, ... }:
{
  name = "jetbrains-jdk-jcef";

  meta.maintainers = with lib.maintainers; [ liff ];

  enableOCR = true;

  nodes.machine =
    { lib, pkgs, ... }:
    let
      jbr-browser-test = pkgs.callPackage ./jbr-browser-test.nix { };
    in
    {
      services.cage.program = lib.getExe jbr-browser-test;
      imports = [ ../common/wayland-cage.nix ];
    };

  testScript = ''
    machine.wait_for_unit('graphical.target')
    machine.wait_for_text('CHROME VERSION', timeout=90)
  '';
}
