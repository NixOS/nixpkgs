{ writeShellApplication, lib }:

writeShellApplication {
  name = "nixos-firewall-tool";

  text = builtins.readFile ./nixos-firewall-tool.sh;

  meta = with lib; {
    description = "Temporarily manipulate the NixOS firewall";
    license = licenses.mit;
    maintainers = with maintainers; [
      clerie
      rvfg
      garyguo
    ];
  };
}
