# Global configuration for mininet
# kernel must have NETNS/VETH/SCHED
{ config, lib, pkgs, ... }:

with lib;

let
  cfg  = config.programs.mininet;

  generatedPath = with pkgs; makeSearchPath "bin"  [
    iperf ethtool iproute2 socat
  ];

  pyEnv = pkgs.python.withPackages(ps: [ ps.mininet-python ]);

  mnexecWrapped = pkgs.runCommand "mnexec-wrapper"
    { buildInputs = [ pkgs.makeWrapper pkgs.pythonPackages.wrapPython ]; }
    ''
      makeWrapper ${pkgs.mininet}/bin/mnexec \
        $out/bin/mnexec \
        --prefix PATH : "${generatedPath}"

      ln -s ${pyEnv}/bin/mn $out/bin/mn

      # mn errors out without a telnet binary
      # pkgs.inetutils brings an undesired ifconfig into PATH see #43105
      ln -s ${pkgs.inetutils}/bin/telnet $out/bin/telnet
    '';
in
{
  options.programs.mininet.enable = mkEnableOption (lib.mdDoc "Mininet");

  config = mkIf cfg.enable {

    virtualisation.vswitch.enable = true;

    environment.systemPackages = [ mnexecWrapped ];
  };
}
