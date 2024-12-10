{
  writeShellApplication,
  iptables,
  lib,
}:

writeShellApplication {
  name = "nixos-firewall-tool";
  text = builtins.readFile ./nixos-firewall-tool.sh;
  runtimeInputs = [
    iptables
  ];

  meta = with lib; {
    description = "Temporarily manipulate the NixOS firewall";
    license = licenses.mit;
    maintainers = with maintainers; [ clerie ];
  };
}
