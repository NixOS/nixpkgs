# VapourSynth {#sec-vapoursynth}

[VapourSynth](https://www.vapoursynth.com/doc/introduction.html) is a framework for video manipulation.

## Using VapourSynth {#sec-vapoursynth-use}

In Nixpkgs, VapourSynth is provided by the package `python3Packages.vapoursynth`.
This package contains the `vapoursynth` Python module as well as the `vspipe` command.
Additionally, the `vapoursynth-editor` package provides the VapourSynth editor, which allows to edit a script and preview the resulting video.

For a simple test, we create a `test.vpy` script containing

```
import vapoursynth
print(vapoursynth.core)
print("it works!")
```

and then run

```shellSession
$ nix-shell -p python3Packages.vapoursynth
[nix-shell:~] vspipe --info test.vpy
VapourSynth Video Processing Library
Copyright (c) 2012-2026 Fredrik Mellbin
  Core R82
  API R4.3
  Options: -
  Number of Threads: 12
  Max Cache Size: 15697

it works!

```


## Using VapourSynth plugins {#sec-vapoursynth-plugins}

Some VapourSynth functionality -- including loading a video from file and most filters -- is actually provided by external plugins.
Since version R74, plugins are distributed as Python packages providing one or more native shared libraries.
VapourSynth discovers them through the standard Python modules search logic and loads them automatically.

In Nixpkgs, a Python environment including VapourSynth and some plugins can be created using the `python3.withPackages` helper function.
For example, using the BestSource plugin to source a video, we create
a script that flips frames horizontally:

```python
from vapoursynth import core
clip = core.bs.VideoSource(source='example.mkv')  # provided by BestSource
clip = core.std.FlipHorizontal(clip)
clip.set_output()
```

To add the plugin to the shell environment and run the script:

```shellSession
$ nix-shell -p ffmpeg 'python3.withPackages (p: [ p.vapoursynth p.vapoursynth-bestsource ])'
[nix-shell:~] vspipe -c y4m flip.vpy - | ffmpeg -i - flipped.mkv
```


## VapourSynth integration {#sec-vapoursynth-integration}

Some programs integrate VapourSynth for real-time video manipulation.

For example, the mpv player supports using VapourSynth for [video filters](https://mpv.io/manual/stable/#video-filters).
mpv can be built with VapourSynth support using the following [overlay](#chap-overlays):

```nix
self: super: {
  mpv-unwrapped = super.mpv-unwrapped.override {
    vapoursynthSupport = true;
  };
}
```

To use VapourSynth plugins in mpv video filters, mpv itself needs to be added to the environment as if it were a Python package. For example:

```nix
pkgs.python3.withPackages (p: [
  p.vapoursynth
  p.vapoursynth-bestsource
  p.vapoursynth-mvtools
  pkgs.mpv
])
```

::: {.note}
In this way, the `mpv` binary will be automatically wrapped so that the Python interpreter embedded within it will be able to discover the VapourSynth plugins.
:::

This also applies to adding VapourSynth plugins to other programs like av1an and VapourSynth editor.
