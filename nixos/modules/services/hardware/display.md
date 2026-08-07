# Customizing display configuration {#module-hardware-display}

This section describes how to customize display configuration using:
- kernel modes
- EDID files

Example situations it can help you with:
- display controllers (external hardware) not advertising EDID at all,
- misbehaving graphics drivers,
- loading custom display configuration before the Display Manager is running,

## Forcing display modes {#module-hardware-display-modes}

In case of very wrong monitor controller and/or video driver combination you can
[force the display to be enabled](https://mjmwired.net/kernel/Documentation/fb/modedb.txt#41)
and skip some driver-side checks by adding `video=<OUTPUT>:e` to `boot.kernelParams`.
This is exactly the case with [`amdgpu` drivers](https://gitlab.freedesktop.org/drm/amd/-/issues/615#note_1987392)

```nix
{
  # force enabled output to skip `amdgpu` checks
  hardware.display.outputs."DP-1".mode = "e";
  # completely disable output no matter what is connected to it
  hardware.display.outputs."VGA-2".mode = "d";

  /*
    equals
    boot.kernelParams = [ "video=DP-1:e" "video=VGA-2:d" ];
  */
}
```

## Crafting custom EDID files {#module-hardware-display-edid-custom}

To make custom EDID binaries discoverable you should first create a derivation storing them at
`$out/lib/firmware/edid/` and secondly add that derivation to `hardware.display.edid.packages` NixOS option:

```nix
{
  hardware.display.edid.packages = [
    (pkgs.runCommand "edid-custom" { } ''
      mkdir -p $out/lib/firmware/edid
      base64 -d > "$out/lib/firmware/edid/custom1.bin" <<'EOF'
      <insert your base64 encoded EDID file here `base64 < /sys/class/drm/card0-.../edid`>
      EOF
      base64 -d > "$out/lib/firmware/edid/custom2.bin" <<'EOF'
      <insert your base64 encoded EDID file here `base64 < /sys/class/drm/card1-.../edid`>
      EOF
    '')
  ];
}
```

There are 2 options significantly easing preparation of EDID files:
- `hardware.display.edid.linuxhw`
- `hardware.display.edid.modelines`

## Assigning EDID files to displays {#module-hardware-display-edid-assign}

To assign available custom EDID binaries to your monitor (video output) use `hardware.display.outputs."<NAME>".edid` option.
Under the hood it adds `drm.edid_firmware` entry to `boot.kernelParams` NixOS option for each configured output:

```nix
{
  hardware.display.outputs."VGA-1".edid = "custom1.bin";
  hardware.display.outputs."VGA-2".edid = "custom2.bin";
  /*
    equals:
    boot.kernelParams = [ "drm.edid_firmware=VGA-1:edid/custom1.bin,VGA-2:edid/custom2.bin" ];
  */
}
```

## Pulling files from linuxhw/EDID database {#module-hardware-display-edid-linuxhw}

`hardware.display.edid.linuxhw` utilizes `pkgs.linuxhw-edid-fetcher` to extract EDID files
from <https://github.com/linuxhw/EDID> based on simple string/regexp search identifying exact entries:

```nix
{
  hardware.display.edid.linuxhw."PG278Q_2014" = [
    "PG278Q"
    "2014"
  ];

  /*
    equals:
    hardware.display.edid.packages = [
      (pkgs.linuxhw-edid-fetcher.override {
        displays = {
          "PG278Q_2014" = [ "PG278Q" "2014" ];
        };
      })
    ];
  */
}
```


## Using XFree86 Modeline definitions {#module-hardware-display-edid-modelines}

`hardware.display.edid.modelines` utilizes `pkgs.edid-generator` package allowing you to
conveniently use [`XFree86 Modeline`](https://en.wikipedia.org/wiki/XFree86_Modeline) entries as EDID binaries:

```nix
{
  hardware.display.edid.modelines."PG278Q_60" =
    "    241.50   2560 2608 2640 2720   1440 1443 1448 1481   -hsync +vsync";
  hardware.display.edid.modelines."PG278Q_120" =
    "   497.75   2560 2608 2640 2720   1440 1443 1448 1525   +hsync -vsync";

  /*
    equals:
    hardware.display.edid.packages = [
      (pkgs.edid-generator.overrideAttrs {
        clean = true;
        modelines = ''
          Modeline "PG278Q_60"      241.50   2560 2608 2640 2720   1440 1443 1448 1481   -hsync +vsync
          Modeline "PG278Q_120"     497.75   2560 2608 2640 2720   1440 1443 1448 1525   +hsync -vsync
        '';
      })
    ];
  */
}
```

## Complete example for Asus PG278Q {#module-hardware-display-pg278q}

And finally this is a complete working example for a 2014 (first) batch of [Asus PG278Q monitor with `amdgpu` drivers](https://gitlab.freedesktop.org/drm/amd/-/issues/615#note_1987392):

```nix
{
  hardware.display.edid.modelines."PG278Q_60" =
    "   241.50   2560 2608 2640 2720   1440 1443 1448 1481   -hsync +vsync";
  hardware.display.edid.modelines."PG278Q_120" =
    "  497.75   2560 2608 2640 2720   1440 1443 1448 1525   +hsync -vsync";

  hardware.display.outputs."DP-1".edid = "PG278Q_60.bin";
  hardware.display.outputs."DP-1".mode = "e";
}
```
