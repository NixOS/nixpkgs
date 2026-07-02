# Boot Problems {#sec-boot-problems}

If NixOS fails to boot, there are a number of kernel command line parameters that may help you to identify or fix the issue. You can add these parameters in the GRUB boot menu by pressing “e” to modify the selected boot entry and editing the line starting with `linux`.

{manpage}`kernel-command-line(7)` documents the kernel parameters accepted by systemd. Those include many that are helpful for debugging boot issues, such as `systemd.debug_shell` and `rescue`. Some also have `rd.`‐prefixed variants that apply to stage 1.

`live.nixos.passwd=password`

: Set the password for the `nixos` live user. This can be used for SSH access if there are issues using the terminal.

If no login prompts or X11 login screens appear (e.g. due to hanging dependencies), you can press Alt+ArrowUp. If you’re lucky, this will start `rescue.target` (described in {manpage}`systemd.special(7)`). (Also note that since most units have a 90-second timeout before systemd gives up on them, the `agetty` login prompts should appear eventually unless something is very wrong.)

## Scripted stage 1 {#sec-boot-problems-scripted-stage-1}

The scripted implementation of stage 1 also understands these boot parameters.

::: {.warning}
The scripted implementation of stage 1 is disabled by default and deprecated. These parameters have no effect, unless systemd stage 1 is explicitly disabled with `boot.initrd.systemd.enable = false;`.
:::

`boot.shell_on_fail`

: Allows the user to start a root shell if something goes wrong in stage 1 of the boot process (the initial ramdisk). This is disabled by default because there is no authentication for the root shell.

  ::: {.note}
  systemd stage 1 alternative: `SYSTEMD_SULOGIN_FORCE=1` for rescue mode, or `rd.systemd.debug_shell` for shell on tty9.
  :::

`boot.debug1`

: Start an interactive shell in stage 1 before anything useful has been done. That is, no modules have been loaded and no file systems have been mounted, except for `/proc` and `/sys`.

  ::: {.note}
  systemd stage 1 alternative: `rd.systemd.break=pre-udev`
  :::

`boot.debug1devices`

: Like `boot.debug1`, but runs stage1 until kernel modules are loaded and device nodes are created. This may help with e.g. making the keyboard work.

  ::: {.note}
  systemd stage 1 alternative: `rd.systemd.break=pre-mount`
  :::

`boot.debug1mounts`

: Like `boot.debug1` or `boot.debug1devices`, but runs stage1 until all filesystems that are mounted during initrd are mounted (see [neededForBoot](#opt-fileSystems._name_.neededForBoot)). As a motivating example, this could be useful if you've forgotten to set [neededForBoot](#opt-fileSystems._name_.neededForBoot) on a file system.

  ::: {.note}
  systemd stage 1 alternative: `rd.systemd.break=pre-switch-root`
  :::

`boot.trace`

: Print every shell command executed by the stage 1 and 2 boot scripts.

  ::: {.note}
  systemd stage 1 alternative: `rd.systemd.log_level=debug`
  :::

Notice that for `boot.shell_on_fail`, `boot.debug1`, `boot.debug1devices`, and `boot.debug1mounts`, if you did **not** select "start the new shell as pid 1", and you `exit` from the new shell, boot will proceed normally from the point where it failed, as if you'd chosen "ignore the error and continue".
