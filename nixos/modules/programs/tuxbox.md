# TuxBox {#module-programs-tuxbox}

[TuxBox](https://github.com/AndyCappDev/tuxbox) is a Linux driver for TourBox devices.

## Input and dialout group {#module-programs-tuxbox-groups}

For the driver to work your user needs to be in the `input` and `dialout` group. This module does
that setup for you, but you need to specify the user for which the setup should be done.

```
programs.tuxbox = {
  enable = true;
  user = [ "john" ];
};
```

## Profile switching {#module-programs-tuxbox-profile-switching}

Profile switching requires the Systemd service to have its path amended with the applications used
to verify the running compositor. The upstream application checks can be found [here in the source
code](https://github.com/AndyCappDev/tuxbox/blob/2827c69fa293fec6d6c00303707dd173c484d291/tuxbox/window_monitor.py#L72).

Otherwise, profile switching will be disabled by the application.

The module tries to handle this for you. However, you can specify the additional packages to add
manually with the option `systemdPathPackages`.

```
programs.tuxbox = {
  enable = true;
  user = [ "john" ];
  systemdPathPackages = [
    pkgs.sway
  ];
};
```

