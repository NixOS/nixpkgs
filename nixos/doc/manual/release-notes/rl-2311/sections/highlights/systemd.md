- [systemd](https://systemd.io) has been updated from v253 to v254, see [the release notes](https://github.com/systemd/systemd/blob/v254/NEWS#L3-L659) for more information on the changes.
    - `boot.resumeDevice` **must be specified** when hibernating if not in EFI mode.
    - systemd may warn your system about the permissions of your ESP partition (often `/boot`), this warning can be ignored for now, we are looking
      into a satisfying solution regarding this problem.
    - Updating with `nixos-rebuild boot` and rebooting is recommended, since in some rare cases the `nixos-rebuild switch` into the new generation on a live system might fail due to missing mount units.
