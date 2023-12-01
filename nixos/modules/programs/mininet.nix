# Global configuration for mininet
# kernel must have NETNS/VETH/SCHED
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.mininet;

  telnet = pkgs.runCommand "inetutils-telnet"
    { }
    ''
      mkdir -p $out/bin
      ln -s ${pkgs.inetutils}/bin/telnet $out/bin
    '';

  generatedPath = with pkgs; makeSearchPath "bin" [
    iperf
    ethtool
    iproute2
    socat
    # mn errors out without a telnet binary
    # pkgs.inetutils brings an undesired ifconfig into PATH see #43105
    nettools
    telnet
  ];

  pyEnv = pkgs.python3.withPackages (ps: [ ps.mininet-python ]);

  mnexecWrapped = pkgs.runCommand "mnexec-wrapper"
    { nativeBuildInputs = [ pkgs.makeWrapper pkgs.python3Packages.wrapPython ]; }
    ''
      makeWrapper ${pkgs.mininet}/bin/mnexec \
        $out/bin/mnexec \
        --prefix PATH : "${generatedPath}"

      makeWrapper ${pyEnv}/bin/mn \
        $out/bin/mn \
        --prefix PYTHONPATH : "${pyEnv}/${pyEnv.sitePackages}" \
        --prefix PATH : "${generatedPath}"
    '';
in
{
  options.programs.mininet.enable = mkEnableOption (lib.mdDoc "Mininet");

  config = mkIf cfg.enable {

    virtualisation.vswitch.enable = true;

    environment.systemPackages = [ mnexecWrapped ];
  };
}
