NixOS profiles covering hardware quirks.

## Setup

Add and update `nixos-hardware` channel:

```
$ sudo nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware
$ sudo nix-channel --update nixos-hardware
```

Then import an appropriate profile path from the table below. For example, to
enable ThinkPad X220 profile, your `imports` in `/etc/nixos/configuration.nix`
should look like:

```
imports = [
  <nixos-hardware/lenovo/thinkpad/x220>
  ./hardware-configuration.nix
];
```

## Incomplete list of Profiles

See code for all available configurations.

| Model                             | Path                                               |
| --------------------------------- | -------------------------------------------------- |
| [Acer Aspire 4810T][]             | `<nixos-hardware/acer/aspire/4810t>`               |
| Airis N990                        | `<nixos-hardware/airis/n990>`                      |
| Apple MacBook Air 4,X             | `<nixos-hardware/apple/macbook-air/4>`             |
| Apple MacBook Air 6,X             | `<nixos-hardware/apple/macbook-air/6>`             |
| [Apple MacBook Pro 10,1][]        | `<nixos-hardware/apple/macbook-pro/10-1>`          |
| Apple MacBook Pro 12,1            | `<nixos-hardware/apple/macbook-pro/12-1>`          |
| BeagleBoard PocketBeagle          | `<nixos-hardware/beagleboard/pocketbeagle>`        |
| [Dell XPS E7240][]                | `<nixos-hardware/dell/e7240>`                      |
| [Dell XPS 13 9360][]              | `<nixos-hardware/dell/xps/13-9360>`                |
| [Dell XPS 13 9370][]              | `<nixos-hardware/dell/xps/13-9370>`                |
| [Dell XPS 13 9380][]              | `<nixos-hardware/dell/xps/13-9380>`                |
| [Dell XPS 15 9550][]              | `<nixos-hardware/dell/xps/15-9550>`                |
| [Inverse Path USB armory][]       | `<nixos-hardware/inversepath/usbarmory>`           |
| Lenovo IdeaPad Z510               | `<nixos-hardware/lenovo/ideapad/z510>`             |
| Lenovo ThinkPad T410              | `<nixos-hardware/lenovo/thinkpad/t410>`            |
| Lenovo ThinkPad T430              | `<nixos-hardware/lenovo/thinkpad/t430>`            |
| Lenovo ThinkPad T440s             | `<nixos-hardware/lenovo/thinkpad/t440s>`           |
| Lenovo ThinkPad T440p             | `<nixos-hardware/lenovo/thinkpad/t440p>`           |
| Lenovo ThinkPad T450s             | `<nixos-hardware/lenovo/thinkpad/t450s>`           |
| Lenovo ThinkPad T460s             | `<nixos-hardware/lenovo/thinkpad/t460s>`           |
| Lenovo ThinkPad T470s             | `<nixos-hardware/lenovo/thinkpad/t470s>`           |
| Lenovo ThinkPad T480s             | `<nixos-hardware/lenovo/thinkpad/t480s>`           |
| Lenovo ThinkPad T490              | `<nixos-hardware/lenovo/thinkpad/t490>`            |
| Lenovo ThinkPad X140e             | `<nixos-hardware/lenovo/thinkpad/x140e>`           |
| Lenovo ThinkPad X220              | `<nixos-hardware/lenovo/thinkpad/x220>`            |
| Lenovo ThinkPad X230              | `<nixos-hardware/lenovo/thinkpad/x230>`            |
| Lenovo ThinkPad X250              | `<nixos-hardware/lenovo/thinkpad/x250>`            |
| [Lenovo ThinkPad X260][]          | `<nixos-hardware/lenovo/thinkpad/x260>`            |
| Lenovo ThinkPad X270              | `<nixos-hardware/lenovo/thinkpad/x270>`            |
| [Lenovo ThinkPad X1 (6th Gen)][]  | `<nixos-hardware/lenovo/thinkpad/x1/6th-gen>`      |
| Lenovo ThinkPad X1 Extreme Gen 2  | `<nixos-hardware/lenovo/thinkpad/x1-extreme/gen2>` |
| [Microsoft Surface Pro 3][]       | `<nixos-hardware/microsoft/surface-pro/3>`         |
| PC Engines APU                    | `<nixos-hardware/pcengines/apu>`                   |
| [Raspberry Pi 2][]                | `<nixos-hardware/raspberry-pi/2>`                  |
| [Samsung Series 9 NP900X3C][]     | `<nixos-hardware/samsung/np900x3c>`                |
| [Purism Librem 13v3][]            | `<nixos-hardware/purism/librem/13v3>`              |
| Supermicro A1SRi-2758F            | `<nixos-hardware/supermicro/a1sri-2758f>`          |
| Supermicro X10SLL-F               | `<nixos-hardware/supermicro/x10sll-f>`             |
| [Toshiba Chromebook 2 `swanky`][] | `<nixos-hardware/toshiba/swanky>`                  |

[Acer Aspire 4810T]: acer/aspire/4810t
[Apple MacBook Pro 10,1]: apple/macbook-pro/10-1
[Dell XPS E7240]: dell/e7240
[Dell XPS 13 9360]: dell/xps/13-9360
[Dell XPS 13 9370]: dell/xps/13-9370
[Dell XPS 13 9380]: dell/xps/13-9380
[Dell XPS 15 9550]: dell/xps/15-9550
[Inverse Path USB armory]: inversepath/usbarmory
[Lenovo ThinkPad X1 (6th Gen)]: lenovo/thinkpad/x1/6th-gen
[Lenovo ThinkPad X260]: lenovo/thinkpad/x260
[Microsoft Surface Pro 3]: microsoft/surface-pro/3
[Raspberry Pi 2]: raspberry-pi/2
[Samsung Series 9 NP900X3C]: samsung/np900x3c
[Purism Librem 13v3]: purism/librem/13v3
[Toshiba Chromebook 2 `swanky`]: toshiba/swanky
