This package depends on DWL being built with the IPC patch found at https://codeberg.org/dwl/dwl-patches/raw/commit/d235f0f88ed069eca234da5a544fb1c6e19f1d33/patches/ipc/ipc.patch

this requires the following to be included in your configuration.nix (or flake)

```
environment.systemPackages = with pkgs; [
  (dwl.overrideAttrs (
    attrs: {
    patches = [ (fetchpatch {
        url = "https://codeberg.org/dwl/dwl-patches/raw/commit/d235f0f88ed069eca234da5a544fb1c6e19f1d33/patches/ipc/ipc.patch";
        sha256 = "sha256-c5225c483aa6217700d2649dd7f67478e2f5f0b60610cc3d0cc0ebedd8356fdf";
      })
      ];
      }))
    ];
```
