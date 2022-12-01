# Booting from a USB flash drive {#sec-booting-from-usb}

The image has to be written verbatim to the USB flash drive for it to be
bootable on UEFI and BIOS systems. Here are the recommended tools to do that.

## Creating bootable USB flash drive with a graphical tool {#sec-booting-from-usb-graphical}

Etcher is a popular and user-friendly tool. It works on Linux, Windows and macOS.

Download it from [balena.io](https://www.balena.io/etcher/), start the program,
select the downloaded NixOS ISO, then select the USB flash drive and flash it.

::: {.warning}
Etcher reports errors and usage statistics by default, which can be disabled in
the settings.
:::

An alternative is [USBImager](https://bztsrc.gitlab.io/usbimager),
which is very simple and does not connect to the internet. Download the version
with write-only (wo) interface for your system. Start the program,
select the image, select the USB flash drive and click "Write".

## Creating bootable USB flash drive from a Terminal on Linux {#sec-booting-from-usb-linux}

1. Plug in the USB flash drive.
2. Find the corresponding device with `lsblk`. You can distinguish them by
   their size.
3. Make sure all partitions on the device are properly unmounted. Replace `sdX`
   with your device (e.g. `sdb`).

  ```ShellSession
  sudo umount /dev/sdX*
  ```

4. Then use the `dd` utility to write the image to the USB flash drive.

  ```ShellSession
  sudo dd if=<path-to-image> of=/dev/sdX bs=4M conv=fsync
  ```

## Creating bootable USB flash drive from a Terminal on macOS {#sec-booting-from-usb-macos}

1. Plug in the USB flash drive.
2. Find the corresponding device with `diskutil list`. You can distinguish them
   by their size.
3. Make sure all partitions on the device are properly unmounted. Replace `diskX`
   with your device (e.g. `disk1`).

  ```ShellSession
  diskutil unmountDisk diskX
  ```

4. Then use the `dd` utility to write the image to the USB flash drive.

  ```ShellSession
  sudo dd if=<path-to-image> of=/dev/rdiskX bs=4m
  ```

  After `dd` completes, a GUI dialog \"The disk
  you inserted was not readable by this computer\" will pop up, which can
  be ignored.

  ::: {.note}
  Using the \'raw\' `rdiskX` device instead of `diskX` with dd completes in
  minutes instead of hours.
  :::

5. Eject the disk when it is finished.

  ```ShellSession
  diskutil eject /dev/diskX
  ```
