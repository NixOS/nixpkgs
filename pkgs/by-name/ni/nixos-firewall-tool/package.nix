{ writeShellApplication, iptables, lib
, nftables, backend ? "iptables"
}:

writeShellApplication ({
  name = "nixos-firewall-tool";

  meta = with lib; {
    description = "Temporarily manipulate the NixOS firewall";
    license = licenses.mit;
    maintainers = with maintainers; [ clerie rvfg ];
  };
} // (
  if backend == "iptables" then {
    text = builtins.readFile ./nixos-firewall-tool.sh;
    runtimeInputs = [ iptables ];

  } else if backend == "nftables" then {
    text = builtins.readFile ./nixos-firewall-tool-nftables.sh;
    runtimeInputs = [ nftables ];

  } else
    throw "Unknown firewall backend."
))
