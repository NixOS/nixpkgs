# How to reset `data` and `etc` directories

This is often useful if you encounter errors from `crowdsec-setup`. Just do the following:

1. Stop the `crowdsec.service` service (if it's running and don't forget the `crowdsec-firewall-bouncer.service`) with `systemctl stop crowdsec.service`.
2. Remove the directories: `rm -rf /etc/crowdsec /var/lib/crowdsec` (adjust the paths to `services.crowdsec.settings.config.config_paths.config_dir` and `services.crowdsec.settings.config.config_paths.data_dir`)
3. Recreate the directories: `systemd-tmpfiles --create`
4. Start the `crowdsec.service` again: `systemctl start crowdsec.service`.

If any errors still persist, feel free to create an [issue](https://github.com/NixOS/nixpkgs/issues).
