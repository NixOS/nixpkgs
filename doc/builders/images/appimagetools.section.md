# pkgs.appimageTools {#sec-pkgs-appimageTools}

`pkgs.appimageTools` is a set of functions for extracting and wrapping [AppImage](https://appimage.org/) files. They are meant to be used if traditional packaging from source is infeasible, or it would take too long. To quickly run an AppImage file, `pkgs.appimage-run` can be used as well.

::: {.warning}
The `appimageTools` API is unstable and may be subject to backwards-incompatible changes in the future.
:::

## AppImage formats {#ssec-pkgs-appimageTools-formats}

There are different formats for AppImages, see [the specification](https://github.com/AppImage/AppImageSpec/blob/74ad9ca2f94bf864a4a0dac1f369dd4f00bd1c28/draft.md#image-format) for details.

- Type 1 images are ISO 9660 files that are also ELF executables.
- Type 2 images are ELF executables with an appended filesystem.

They can be told apart with `file -k`:

```ShellSession
$ file -k type1.AppImage
type1.AppImage: ELF 64-bit LSB executable, x86-64, version 1 (SYSV) ISO 9660 CD-ROM filesystem data 'AppImage' (Lepton 3.x), scale 0-0,
spot sensor temperature 0.000000, unit celsius, color scheme 0, calibration: offset 0.000000, slope 0.000000, dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.6.18, BuildID[sha1]=d629f6099d2344ad82818172add1d38c5e11bc6d, stripped\012- data

$ file -k type2.AppImage
type2.AppImage: ELF 64-bit LSB executable, x86-64, version 1 (SYSV) (Lepton 3.x), scale 232-60668, spot sensor temperature -4.187500, color scheme 15, show scale bar, calibration: offset -0.000000, slope 0.000000 (Lepton 2.x), scale 4111-45000, spot sensor temperature 412442.250000, color scheme 3, minimum point enabled, calibration: offset -75402534979642766821519867692934234112.000000, slope 5815371847733706829839455140374904832.000000, dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.6.18, BuildID[sha1]=79dcc4e55a61c293c5e19edbd8d65b202842579f, stripped\012- data
```

Note how the type 1 AppImage is described as an `ISO 9660 CD-ROM filesystem`, and the type 2 AppImage is not.

## Wrapping {#ssec-pkgs-appimageTools-wrapping}

To create a derivation for a appimage you can use the `wrapType2` builder. It is a wrapper around `buildFHSUserEnv` that extracts the appimage for you and generates a FHS environment to run it in. Any attribute `buildFHSUserEnv` accepts will also be valid in `wrapType2` derivations.

Example:

```nix
appimageTools.wrapType2 rec {
  pname = "patchwork";
  version = "4.11.4";

  src = fetchurl {
    url = "https://github.com/ssbc/patchwork/releases/download/v${version}/Patchwork-${version}-linux-x86_64.AppImage";
    sha256 = "1blsprpkvm0ws9b96gb36f0rbf8f5jgmw4x6dsb1kswr4ysf591s";
  };

  extraPkgs = pkgs: with pkgs; [ ];

  extraInstall = appimageContents: ''
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';
}
```

- `name` specifies the name of the resulting image.

  Note that `pname` and `version` can be specified instead as well.

- `src` specifies the AppImage file to extract.

- `extraInstall` specifies extra commands used for the install phase.

  It allows you to reference the contents of the extracted appimage using a function argument, as shown in the example.

- `extraPkgs` allows you to include additional packages inside the FHS environment your AppImage is going to run in.
   The attribute is specified as a function that takes as argument the Nixpkgs package set.

  There are a few ways to learn which dependencies an application needs:

  - Looking through the extracted AppImage files, reading its scripts and running `patchelf` and `ldd` on its executables.

  This can also be done in `appimage-run`, by setting `APPIMAGE_DEBUG_EXEC=bash`.

  - Running `strace -vfefile` on the wrapped executable, looking for libraries that can't be found.
