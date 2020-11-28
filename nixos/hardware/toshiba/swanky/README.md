# Toshiba Chromebook 2 `swanky`

There might be a way to install NixOS without hardware modifications (via
enabled developer mode and SeaBIOS boot on Ctrl+L), however I'd highly
recommend replacing Google's Coreboot payload with Tianocore: that allows for
proper virtualization, suspend, removes annoying developer mode screen, and
generally just works much better.

These instructions carry some risk of bricking your device, since you'll be
reflashing BIOS. Risk is rather low, but please for the love of god make a BIOS
backup and store it someplace safe. That's the only way to reinstall ChromeOS
back after this procedure (BIOS image has licensing info), and it's much easier
to use a known good state to unbrick the laptop if things go wrong.

If you ever get unlucky, you can unbrick your device using Raspberry Pi,
some cables and a SOIC clip, see:
http://sicarul.com/how-to-un-brick-your-toshiba-chromebook-2-gandof-without-invoking-any-demons/

## Enable developer mode

This will wipe all user data and settings from the laptop.

Power off, then hold ESC + Refresh (F3) and abruptly press power button. You
should see "Chrome OS is missing or damaged" message. Press Ctrl+D. Press enter
at the next screen, then press Ctrl+D again. Wait until the laptop boots into
ChromeOS, then power it off.

## Disable hardware-backed BIOS write protection

Follow the first part of the guide at:
https://github.com/brendenyule/NativeToshibaCB2Guide/wiki/Remove-Write-Protect

Ignore SeaBIOS section. I also used some ductape over #5 to make sure that
metallic motherboard shield would not re-enable write protection.

## Flash Coreboot + Tianocore BIOS

Prepare a FAT32-formatted flash drive for BIOS backup in advance.

Go through ChromeOS installation dialogues until you have network access and
are able to log into a guest session. Open Chrome, press Ctrl+Alt+T to open
`crosh`, type in `shell` to get a real shell. Then, run:

```
$ cd ~
$ curl -LO https://mrchromebox.tech/firmware-util.sh
$ sudo bash firmware-util.sh
```

Choose "Install/Update Full ROM Firmware" option and follow instructions.
Do not skip BIOS backup!

Documentation: https://mrchromebox.tech/#fwscript

## Enable hardware-backed BIOS write protection

This is a cool security feature, so after flashing Coreboot + Tianocore BIOS
and making sure new BIOS works, consider re-enabling BIOS protection. Just put
in the missing screw #5.

## Install NixOS

`dd` an image on a flash drive, partition the drive, etc. On some later models,
you can swap SSD with any other 2242 M.2 SATA SSD, but on `swanky`, you have
to live with what you have (16GB eMMC). I recommend `256MB` for EFI partition,
and the rest for `/`.
