# Booting from a USB Drive {#sec-booting-from-usb}

For systems without CD drive, the NixOS live CD can be booted from a USB
stick. You can use the `dd` utility to write the image:
`dd if=path-to-image of=/dev/sdX`. Be careful about specifying the correct
drive; you can use the `lsblk` command to get a list of block devices.

::: {.note}
::: {.title}
On macOS
:::

```ShellSession
$ diskutil list
[..]
/dev/diskN (external, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
[..]
$ diskutil unmountDisk diskN
Unmount of all volumes on diskN was successful
$ sudo dd if=nix.iso of=/dev/rdiskN bs=1M
```

Using the \'raw\' `rdiskN` device instead of `diskN` completes in
minutes instead of hours. After `dd` completes, a GUI dialog \"The disk
you inserted was not readable by this computer\" will pop up, which can
be ignored.
:::

The `dd` utility will write the image verbatim to the drive, making it
the recommended option for both UEFI and non-UEFI installations.
