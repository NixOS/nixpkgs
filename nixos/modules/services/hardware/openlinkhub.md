# OpenLinkHub {#module-services-openlinkhub}

[OpenLinkHub](https://github.com/jurkovic-nikola/OpenLinkHub) is an open-source
controller daemon for Corsair iCUE LINK hubs, AIOs and other supported HID/USB
peripherals. It exposes a local web UI for device configuration and control.

To enable OpenLinkHub, add the following to your {file}`configuration.nix`:

```nix
{
  services.hardware.openlinkhub.enable = true;
}
```

This starts the daemon as a system service under an unprivileged
`openlinkhub` user, installs the shipped udev rules and grants the daemon
access to matched Corsair devices via the `openlinkhub` group.

## Web UI {#module-services-openlinkhub-web-ui}

The web UI is served on `http://127.0.0.1:27003` by default. Both listen
address and port are stored in {file}`/var/lib/openlinkhub/config.json` and
must be changed through the UI (or by editing the file while the service is
stopped). If you expose the UI on a non-loopback address, open the
corresponding port in {option}`networking.firewall.allowedTCPPorts`
yourself.

## State and data {#module-services-openlinkhub-state}

All runtime state lives in {file}`/var/lib/openlinkhub`:

- {file}`config.json` — daemon settings, rewritten by the UI.
- {file}`database/` — device presets, LCD images and language files.
  Seeded from the package on first start and preserved across rebuilds and
  restarts (the seed uses `cp -n`, so user changes are never overwritten).

## SCUF gamepad emulation {#module-services-openlinkhub-uinput}

SCUF gamepad emulation requires the `uinput` kernel module. It is normally
autoloaded on access via the shipped udev rule. If it is not, set:

```nix
{
  boot.kernelModules = [ "uinput" ];
}
```

## Direct device access {#module-services-openlinkhub-group}

Users who need direct access to Corsair devices outside the daemon (for
example for debugging) can be added to the `openlinkhub` group:

```nix
{
  users.users.alice.extraGroups = [ "openlinkhub" ];
}
```

## Limitations {#module-services-openlinkhub-limitations}

- **No declarative configuration.** The daemon owns and rewrites
  {file}`config.json` at runtime, so no NixOS options are provided beyond
  enabling the service. Configure through the web UI.
- **No Home Manager module.** OpenLinkHub's user-space installation still
  requires system-level udev rules, a system group and adding the user to
  it — all root operations. A pure Home Manager module cannot provide a
  working setup on its own.
