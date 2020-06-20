NixOS profiles covering hardware quirks.

## Setup

Then import an appropriate profile path from the table below, using `pkgs.path`. For example, to
enable ThinkPad X220 profile, your `imports` in `/etc/nixos/configuration.nix`
should look like:

```
{ pkgs, config ... }:

imports = [
  "<nixpkgs/nixos/hardware/lenovo/thinkpad/x220>
  ./hardware-configuration.nix
];
```

## Incomplete list of Profiles

See code for all available configurations.

| Model                             | Path                                               |
| --------------------------------- | -------------------------------------------------- |
| [Acer Aspire 4810T][]             | `<nixpkgs/nixos/hardware/acer/aspire/4810t>`               |
| Airis N990                        | `<nixpkgs/nixos/hardware/airis/n990>`                      |
| Apple MacBook Air 3,X             | `<nixpkgs/nixos/hardware/apple/macbook-air/3>`             |
| Apple MacBook Air 4,X             | `<nixpkgs/nixos/hardware/apple/macbook-air/4>`             |
| Apple MacBook Air 6,X             | `<nixpkgs/nixos/hardware/apple/macbook-air/6>`             |
| [Apple MacBook Pro 10,1][]        | `<nixpkgs/nixos/hardware/apple/macbook-pro/10-1>`          |
| Apple MacBook Pro 12,1            | `<nixpkgs/nixos/hardware/apple/macbook-pro/12-1>`          |
| BeagleBoard PocketBeagle          | `<nixpkgs/nixos/hardware/beagleboard/pocketbeagle>`        |
| Dell Latitude 3480                | `<nixpkgs/nixos/hardware/dell/latitude/3480>`              |
| [Dell XPS E7240][]                | `<nixpkgs/nixos/hardware/dell/e7240>`                      |
| [Dell XPS 13 7390][]              | `<nixpkgs/nixos/hardware/dell/xps/13-7390>`                |
| [Dell XPS 13 9360][]              | `<nixpkgs/nixos/hardware/dell/xps/13-9360>`                |
| [Dell XPS 13 9370][]              | `<nixpkgs/nixos/hardware/dell/xps/13-9370>`                |
| [Dell XPS 13 9380][]              | `<nixpkgs/nixos/hardware/dell/xps/13-9380>`                |
| [Dell XPS 15 7590][]              | `<nixpkgs/nixos/hardware/dell/xps/15-7590>`                |
| [Dell XPS 15 9550][]              | `<nixpkgs/nixos/hardware/dell/xps/15-9550>`                |
| [Dell XPS 15 9560][]              | `<nixpkgs/nixos/hardware/dell/xps/15-9560>`                |
| [Dell XPS 15 9560, intel only][]  | `<nixpkgs/nixos/hardware/dell/xps/15-9560/intel>`          |
| [Dell XPS 15 9560, nvidia only][] | `<nixpkgs/nixos/hardware/dell/xps/15-9560/nvidia>`         |
| [Google Pixelbook][]              | `<nixpkgs/nixos/hardware/google/pixelbook>`                |
| [Inverse Path USB armory][]       | `<nixpkgs/nixos/hardware/inversepath/usbarmory>`           |
| Lenovo IdeaPad Z510               | `<nixpkgs/nixos/hardware/lenovo/ideapad/z510>`             |
| Lenovo ThinkPad E495              | `<nixpkgs/nixos/hardware/lenovo/thinkpad/e495>`            |
| Lenovo ThinkPad L13               | `<nixpkgs/nixos/hardware/lenovo/thinkpad/l13>`             |
| Lenovo ThinkPad P53               | `<nixpkgs/nixos/hardware/lenovo/thinkpad/p53>`             |
| Lenovo ThinkPad T410              | `<nixpkgs/nixos/hardware/lenovo/thinkpad/t410>`            |
| Lenovo ThinkPad T420              | `<nixpkgs/nixos/hardware/lenovo/thinkpad/t420>`            |
| Lenovo ThinkPad T430              | `<nixpkgs/nixos/hardware/lenovo/thinkpad/t430>`            |
| Lenovo ThinkPad T440s             | `<nixpkgs/nixos/hardware/lenovo/thinkpad/t440s>`           |
| Lenovo ThinkPad T440p             | `<nixpkgs/nixos/hardware/lenovo/thinkpad/t440p>`           |
| Lenovo ThinkPad T450s             | `<nixpkgs/nixos/hardware/lenovo/thinkpad/t450s>`           |
| Lenovo ThinkPad T460s             | `<nixpkgs/nixos/hardware/lenovo/thinkpad/t460s>`           |
| Lenovo ThinkPad T470s             | `<nixpkgs/nixos/hardware/lenovo/thinkpad/t470s>`           |
| Lenovo ThinkPad T480s             | `<nixpkgs/nixos/hardware/lenovo/thinkpad/t480s>`           |
| Lenovo ThinkPad T490              | `<nixpkgs/nixos/hardware/lenovo/thinkpad/t490>`            |
| Lenovo ThinkPad T495              | `<nixpkgs/nixos/hardware/lenovo/thinkpad/t495>`            |
| Lenovo ThinkPad X140e             | `<nixpkgs/nixos/hardware/lenovo/thinkpad/x140e>`           |
| Lenovo ThinkPad X220              | `<nixpkgs/nixos/hardware/lenovo/thinkpad/x220>`            |
| Lenovo ThinkPad X230              | `<nixpkgs/nixos/hardware/lenovo/thinkpad/x230>`            |
| Lenovo ThinkPad X250              | `<nixpkgs/nixos/hardware/lenovo/thinkpad/x250>`            |
| [Lenovo ThinkPad X260][]          | `<nixpkgs/nixos/hardware/lenovo/thinkpad/x260>`            |
| Lenovo ThinkPad X270              | `<nixpkgs/nixos/hardware/lenovo/thinkpad/x270>`            |
| Lenovo ThinkPad X280              | `<nixpkgs/nixos/hardware/lenovo/thinkpad/x280>`            |
| [Lenovo ThinkPad X1 (6th Gen)][]  | `<nixpkgs/nixos/hardware/lenovo/thinkpad/x1/6th-gen>`      |
| [Lenovo ThinkPad X1 (7th Gen)][]  | `<nixpkgs/nixos/hardware/lenovo/thinkpad/x1/7th-gen>`      |
| Lenovo ThinkPad X1 Extreme Gen 2  | `<nixpkgs/nixos/hardware/lenovo/thinkpad/x1-extreme/gen2>` |
| [Microsoft Surface Pro 3][]       | `<nixpkgs/nixos/hardware/microsoft/surface-pro/3>`         |
| PC Engines APU                    | `<nixpkgs/nixos/hardware/pcengines/apu>`                   |
| [Raspberry Pi 2][]                | `<nixpkgs/nixos/hardware/raspberry-pi/2>`                  |
| [Samsung Series 9 NP900X3C][]     | `<nixpkgs/nixos/hardware/samsung/np900x3c>`                |
| [Purism Librem 13v3][]            | `<nixpkgs/nixos/hardware/purism/librem/13v3>`              |
| [Purism Librem 15v3][]            | `<nixpkgs/nixos/hardware/purism/librem/15v3>`              |
| Supermicro A1SRi-2758F            | `<nixpkgs/nixos/hardware/supermicro/a1sri-2758f>`          |
| Supermicro X10SLL-F               | `<nixpkgs/nixos/hardware/supermicro/x10sll-f>`             |
| [Toshiba Chromebook 2 `swanky`][] | `<nixpkgs/nixos/hardware/toshiba/swanky>`                  |
| [Tuxedo InfinityBook v4][]        | `<nixpkgs/nixos/hardware/tuxedo/infinitybook/v4>`          |

[Acer Aspire 4810T]: acer/aspire/4810t
[Apple MacBook Pro 10,1]: apple/macbook-pro/10-1
[Dell XPS E7240]: dell/e7240
[Dell XPS 13 7390]: dell/xps/13-7390
[Dell XPS 13 9360]: dell/xps/13-9360
[Dell XPS 13 9370]: dell/xps/13-9370
[Dell XPS 13 9380]: dell/xps/13-9380
[Dell XPS 15 7590]: dell/xps/15-7590
[Dell XPS 15 9550]: dell/xps/15-9550
[Dell XPS 15 9560]: dell/xps/15-9560
[Dell XPS 15 9560, intel only]: dell/xps/15-9560/intel
[Dell XPS 15 9560, nvidia only]: dell/xps/15-9560/nvidia
[Google Pixelbook]: google/pixelbook
[Inverse Path USB armory]: inversepath/usbarmory
[Lenovo ThinkPad X1 (6th Gen)]: lenovo/thinkpad/x1/6th-gen
[Lenovo ThinkPad X1 (7th Gen)]: lenovo/thinkpad/x1/7th-gen
[Lenovo ThinkPad X260]: lenovo/thinkpad/x260
[Microsoft Surface Pro 3]: microsoft/surface-pro/3
[Raspberry Pi 2]: raspberry-pi/2
[Samsung Series 9 NP900X3C]: samsung/np900x3c
[Purism Librem 13v3]: purism/librem/13v3
[Purism Librem 13v5]: purism/librem/13v5
[Toshiba Chromebook 2 `swanky`]: toshiba/swanky
[Tuxedo InfinityBook v4]: nixos-hardware/tuxedo/infinitybook/v4

## How to contribute a new device profile

1. Add your device profile expression in the appropriate directory
2. Link it in the table in README.md
3. Run ./tests/run.py to test it. The test script script will parse all the profiles from the README.md
