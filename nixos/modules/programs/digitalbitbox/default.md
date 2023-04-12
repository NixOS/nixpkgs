# Digital Bitbox {#module-programs-digitalbitbox}

Digital Bitbox is a hardware wallet and second-factor authenticator.

The `digitalbitbox` programs module may be installed by setting
`programs.digitalbitbox` to `true` in a manner similar to
```
programs.digitalbitbox.enable = true;
```
and bundles the `digitalbitbox` package (see [](#sec-digitalbitbox-package)),
which contains the `dbb-app` and `dbb-cli` binaries, along with the hardware
module (see [](#sec-digitalbitbox-hardware-module)) which sets up the necessary
udev rules to access the device.

Enabling the digitalbitbox module is pretty much the easiest way to get a
Digital Bitbox device working on your system.

For more information, see <https://digitalbitbox.com/start_linux>.

## Package {#sec-digitalbitbox-package}

The binaries, `dbb-app` (a GUI tool) and `dbb-cli` (a CLI tool), are available
through the `digitalbitbox` package which could be installed as follows:
```
environment.systemPackages = [
  pkgs.digitalbitbox
];
```

## Hardware {#sec-digitalbitbox-hardware-module}

The digitalbitbox hardware package enables the udev rules for Digital Bitbox
devices and may be installed as follows:
```
hardware.digitalbitbox.enable = true;
```

In order to alter the udev rules, one may provide different values for the
`udevRule51` and `udevRule52` attributes by means of overriding as follows:
```
programs.digitalbitbox = {
  enable = true;
  package = pkgs.digitalbitbox.override {
    udevRule51 = "something else";
  };
};
```
