# Boot Problems {#sec-boot-problems}

If NixOS fails to boot, there are a number of kernel command line parameters that may help you to identify or fix the issue. You can add these parameters in the GRUB boot menu by pressing “e” to modify the selected boot entry and editing the line starting with `linux`. The following are some useful kernel command line parameters that are recognised by the NixOS boot scripts or by systemd:

`boot.shell_on_fail`

: Allows the user to start a root shell if something goes wrong in stage 1 of the boot process (the initial ramdisk). This is disabled by default because there is no authentication for the root shell.

`boot.debug1`

: Start an interactive shell in stage 1 before anything useful has been done. That is, no modules have been loaded and no file systems have been mounted, except for `/proc` and `/sys`.

`boot.debug1devices`

: Like `boot.debug1`, but runs stage1 until kernel modules are loaded and device nodes are created. This may help with e.g. making the keyboard work.

`boot.debug1mounts`

: Like `boot.debug1` or `boot.debug1devices`, but runs stage1 until all filesystems that are mounted during initrd are mounted (see [neededForBoot](#opt-fileSystems._name_.neededForBoot)). As a motivating example, this could be useful if you've forgotten to set [neededForBoot](#opt-fileSystems._name_.neededForBoot) on a file system.

`boot.trace`

: Print every shell command executed by the stage 1 and 2 boot scripts.

`single`

: Boot into rescue mode (a.k.a. single user mode). This will cause systemd to start nothing but the unit `rescue.target`, which runs `sulogin` to prompt for the root password and start a root login shell. Exiting the shell causes the system to continue with the normal boot process.

`systemd.log_level=debug` `systemd.log_target=console`

: Make systemd very verbose and send log messages to the console instead of the journal. For more parameters recognised by systemd, see systemd(1).

In addition, these arguments are recognised by the live image only:

`live.nixos.passwd=password`

: Set the password for the `nixos` live user. This can be used for SSH access if there are issues using the terminal.

Notice that for `boot.shell_on_fail`, `boot.debug1`, `boot.debug1devices`, and `boot.debug1mounts`, if you did **not** select "start the new shell as pid 1", and you `exit` from the new shell, boot will proceed normally from the point where it failed, as if you'd chosen "ignore the error and continue".

If no login prompts or X11 login screens appear (e.g. due to hanging dependencies), you can press Alt+ArrowUp. If you’re lucky, this will start rescue mode (described above). (Also note that since most units have a 90-second timeout before systemd gives up on them, the `agetty` login prompts should appear eventually unless something is very wrong.)
