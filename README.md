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

## Profiles

| Model                             | Path                                       |
| --------------------------------- | ------------------------------------------ |
| [Acer Aspire 4810T][]             | `<nixos-hardware/acer/aspire/4810t>`       |
| Airis N990                        | `<nixos-hardware/airis/n990>`              |
| Apple MacBook Air 4,X             | `<nixos-hardware/apple/macbook-air/4>`     |
| Apple MacBook Air 6,X             | `<nixos-hardware/apple/macbook-air/6>`     |
| [Apple MacBook Pro 10,1][]        | `<nixos-hardware/apple/macbook-pro/10-1>`  |
| Apple MacBook Pro 12,1            | `<nixos-hardware/apple/macbook-pro/12-1>`  |
| [Dell XPS 15 9550][]              | `<nixos-hardware/dell/xps/15-9550>`        |
| [Inverse Path USB armory][]       | `<nixos-hardware/inversepath/usbarmory>`   |
| Lenovo IdeaPad Z510               | `<nixos-hardware/lenovo/ideapad/z510>`     |
| Lenovo ThinkPad T410              | `<nixos-hardware/lenovo/thinkpad/t410>`    |
| Lenovo ThinkPad T440p             | `<nixos-hardware/lenovo/thinkpad/t440p>`   |
| Lenovo ThinkPad T460s             | `<nixos-hardware/lenovo/thinkpad/t460s>`   |
| Lenovo ThinkPad X140e             | `<nixos-hardware/lenovo/thinkpad/x140e>`   |
| Lenovo ThinkPad X220              | `<nixos-hardware/lenovo/thinkpad/x220>`    |
| Lenovo ThinkPad X230              | `<nixos-hardware/lenovo/thinkpad/x230>`    |
| Lenovo ThinkPad X250              | `<nixos-hardware/lenovo/thinkpad/x250>`    |
| Lenovo ThinkPad X270              | `<nixos-hardware/lenovo/thinkpad/x270>`    |
| [Microsoft Surface Pro 3][]       | `<nixos-hardware/microsoft/surface-pro/3>` |
| PC Engines APU                    | `<nixos-hardware/pcengines/apu>`           |
| [Raspberry Pi 2][]                | `<nixos-hardware/raspberry-pi/2>`          |
| [Samsung Series 9 NP900X3C][]     | `<nixos-hardware/samsung/np900x3c>`        |
| [Purism Librem 13v3][]            | `<nixos-hardware/purism/librem/13v3>`      |
| Supermicro A1SRi-2758F            | `<nixos-hardware/supermicro/a1sri-2758f>`  |
| Supermicro X10SLL-F               | `<nixos-hardware/supermicro/x10sll-f>`     |
| [Toshiba Chromebook 2 `swanky`][] | `<nixos-hardware/toshiba/swanky>`          |

[Acer Aspire 4810T]: acer/aspire/4810t
[Apple MacBook Pro 10,1]: apple/macbook-pro/10-1
[Dell XPS 15 9550]: dell/xps/15-9550
[Inverse Path USB armory]: inversepath/usbarmory
[Microsoft Surface Pro 3]: microsoft/surface-pro/3
[Raspberry Pi 2]: raspberry-pi/2
[Samsung Series 9 NP900X3C]: samsung/np900x3c
[Purism Librem 13v3]: purism/librem/13v3
[Toshiba Chromebook 2 `swanky`]: toshiba/swanky
