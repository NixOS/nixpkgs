# NixOS Facter {#module-hardware-facter}

*Source:* {file}`modules/hardware/facter`

*Upstream documentation:* <https://nix-community.github.io/nixos-facter/>

NixOS Facter provides automatic hardware detection and configuration for NixOS systems.
It generates a machine-readable JSON report capturing detailed hardware information,
which NixOS modules then use to automatically configure appropriate drivers, kernel modules,
and system settings.

## Generating a Hardware Report {#module-hardware-facter-generating}

To generate a hardware report, run the following command as root on the target machine:

```console
$ sudo nix-shell -p nixos-facter --run 'nixos-facter -o facter.json'
```

This scans your system and produces a JSON report containing:

- System architecture
- Virtualization environment (if any)
- Hardware details (CPU, GPU, network controllers, disks, etc.)
- SMBIOS/DMI information

## Using the Report {#module-hardware-facter-usage}

Add the generated report to your NixOS configuration:

```nix
{
  hardware.facter.reportPath = ./facter.json;
}
```

Alternatively, you can inline the report directly:

```nix
{
  hardware.facter.report = builtins.fromJSON (builtins.readFile ./facter.json);
}
```

## What Gets Configured {#module-hardware-facter-features}

Based on the hardware report, NixOS Facter automatically configures:

- **System**: Sets [](#opt-nixpkgs.hostPlatform) based on detected architecture
- **Firmware**: Enables [](#opt-hardware.enableRedistributableFirmware) and CPU microcode updates on bare-metal
- **Boot**: Configures UEFI support and loads initrd modules for storage controllers, disks, and input devices
- **Virtualization**: Detects VMs (QEMU/KVM, VirtualBox, Hyper-V, Parallels) and enables appropriate guest support
- **Graphics**: Enables [](#opt-hardware.graphics.enable) and loads GPU kernel modules
- **Networking**: Configures DHCP on detected interfaces and enables WiFi firmware
- **Bluetooth**: Enables [](#opt-hardware.bluetooth.enable) when hardware is detected
- **Fingerprint**: Enables [](#opt-services.fprintd.enable) for supported readers
- **Cameras**: Enables [](#opt-hardware.ipu6.enable) for Intel IPU6 webcams

## Debugging {#module-hardware-facter-debugging}

To understand what changes NixOS Facter makes to your system closure, use the built-in debugging tools:

### nvd diff {#module-hardware-facter-debugging-nvd}

Shows packages added and removed by enabling facter.

With flakes:
```console
$ nix run .#nixosConfigurations.<hostname>.config.hardware.facter.debug.nvd
```

Without flakes:
```console
$ nix-build '<nixpkgs/nixos>' -A config.hardware.facter.debug.nvd -I nixos-config=./configuration.nix
$ ./result/bin/facter-nvd-diff
```

### nix-diff {#module-hardware-facter-debugging-nix-diff}

Shows detailed derivation differences.

With flakes:
```console
$ nix run .#nixosConfigurations.<hostname>.config.hardware.facter.debug.nix-diff
```

Without flakes:
```console
$ nix-build '<nixpkgs/nixos>' -A config.hardware.facter.debug.nix-diff -I nixos-config=./configuration.nix
$ ./result/bin/facter-nix-diff
```

## Options {#module-hardware-facter-options}

A complete list of options for the facter module may be found [here](#opt-hardware.facter.report).
