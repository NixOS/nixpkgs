# Overlayfs {#sec-overlayfs}

NixOS offers a convenient abstraction to create both read-only as well writable
overlays.

```nix
{
  fileSystems = {
    "/writable-overlay" = {
      overlay = {
        lowerdir = [ writableOverlayLowerdir ];
        upperdir = "/.rw-writable-overlay/upper";
        workdir = "/.rw-writable-overlay/work";
      };
      # Mount the writable overlay in the initrd.
      neededForBoot = true;
    };
    "/readonly-overlay".overlay.lowerdir = [
      writableOverlayLowerdir
      writableOverlayLowerdir2
    ];
  };
}
```

If `upperdir` and `workdir` are not null, they will be created before the
overlay is mounted.

To mount an overlay as read-only, you need to provide at least two `lowerdir`s.
