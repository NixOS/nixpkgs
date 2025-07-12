complete -c nixos-firewall-tool -f
complete -c nixos-firewall-tool -k -a reset -d 'Reset firewall configuration to system settings' -n "__fish_is_first_token"
complete -c nixos-firewall-tool -k -a show -d 'Show all firewall rules' -n "__fish_is_first_token"
complete -c nixos-firewall-tool -k -a open -d 'Open a port temporarily' -n "__fish_is_first_token"
complete -c nixos-firewall-tool -k -a "tcp udp" -n "__fish_seen_subcommand_from open && __fish_is_nth_token 2"
