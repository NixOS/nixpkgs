# Apple MacBook Pro 11,5

This configuration will **not** work with MacBook Pro 11,2 or 11,3 models.

## Notable features

* Prevent intermittent USB 3.0 controller wakeup signal when the lid is closed. Without this fix your laptop may get very hot and drain the battery after waking up in your laptop bag.

  You can see for yourself which devices are allowed to wake up your laptop using the command:

  ```shell
  cat /proc/acpi/wakeup
  ```

  This fix works for Linux kernel 3.13 and above.

  Sources:

  * [Fix unwanted laptop resume after lid is closed](https://medium.com/@laurynas.karvelis_95228/install-arch-linux-on-macbook-pro-11-2-retina-install-guide-for-year-2017-2034ceed4cb2#66ba)
  * [Arch wiki: MacBookPro11,x Suspend](https://wiki.archlinux.org/index.php/MacBookPro11,x#Suspend)
  * [simonvandel/dotfiles (nix config)](https://github.com/simonvandel/dotfiles/blob/f254a4a607257faee295ce798ed215273c342850/nixos/vandel-macair/configuration.nix#L45)

## Graphics

The [MacBookPro11,4 and MacBookPro11,5](https://support.apple.com/kb/SP719) models ship with a discrete ATI graphics card (whereas MacBookPro11,2 and MacBookPro11,3 ship with NVidia cards). This is alongside the usual integrated Intel GPU.

You may wish to look into dynamic switching between integrated and discrete graphics, but this config doesn't attempt it.

## Additional resources

* Arch linux wiki: [MacBookPro11,x](https://wiki.archlinux.org/index.php/MacBookPro11,x)
* Kernel patches: [MacBookPro11,x](https://bugzilla.kernel.org/buglist.cgi?quicksearch=macbookpro11)
