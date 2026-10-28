# Boot Problems {#sec-boot-problems}

If NixOS fails to boot, there are a number of kernel command line parameters that may help you to identify or fix the issue. You can add these parameters in the GRUB boot menu by pressing “e” to modify the selected boot entry and editing the line starting with `linux`.

{manpage}`kernel-command-line(7)` documents the kernel parameters accepted by systemd. Those include many that are helpful for debugging boot issues, such as `systemd.debug_shell` and `rescue`. Some also have `rd.`‐prefixed variants that apply to stage 1.

`live.nixos.passwd=password`

: Set the password for the `nixos` live user. This can be used for SSH access if there are issues using the terminal.

If no login prompts or X11 login screens appear (e.g. due to hanging dependencies), you can press Alt+ArrowUp. If you’re lucky, this will start `rescue.target` (described in {manpage}`systemd.special(7)`). (Also note that since most units have a 90-second timeout before systemd gives up on them, the `agetty` login prompts should appear eventually unless something is very wrong.)
