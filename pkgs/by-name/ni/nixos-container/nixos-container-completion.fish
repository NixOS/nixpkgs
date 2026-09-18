set -l containercmds destroy restart start stop terminate status update login root-login run show-ip show-host-key
set -l subcommands list create $containercmds

complete -c nixos-container -f
complete -c nixos-container -n "not __fish_seen_subcommand_from $subcommands" -a "$subcommands"
complete -c nixos-container \
    -n "__fish_seen_subcommand_from $containercmds" \
    -n "test 2 -eq (__fish_number_of_cmd_args_wo_opts)" \
    -a "(nixos-container list)"

# create flags
for flag in nixos-path system-path config-file;
    complete -c nixos-container -n "__fish_seen_subcommand_from create" -l $flag -Fr
end

for flag in config flake ensure-unique-name auto-start bridge port host-address local-address;
    complete -c nixos-container -n "__fish_seen_subcommand_from create" -l $flag
end

# update flags
for flag in nixos-path config-file;
    complete -c nixos-container -n "__fish_seen_subcommand_from update" -l $flag -Fr
end

for flag in config flake;
    complete -c nixos-container -n "__fish_seen_subcommand_from update" -l $flag
end
