nixos-rebuild(8) ["nixpkgs"]
; quick summary:
; # new section
; comments starts with ;
; - this is a list
; 	- sub-list
; - *bold*: _underline_, force a line break++
; - [tables], \[ can be used to force an actual [
; . numbered list
; please configure your editor to use hard tabs
; see `man 5 scdoc` for more information about syntax
; or https://man.archlinux.org/man/scdoc.5.en

# NAME

nixos-rebuild - reconfigure a NixOS machine

# SYNOPSIS

; document here only non-deprecated flags
_nixos-rebuild_ \[--verbose] [--quiet] [--max-jobs MAX_JOBS] [--cores CORES] [--log-format LOG_FORMAT] [--keep-going] [--keep-failed] [--fallback] [--repair] [--option OPTION OPTION] [--builders BUILDERS] [--include INCLUDE]++
	\[--print-build-logs] [--show-trace] [--accept-flake-config] [--refresh] [--impure] [--offline] [--no-net] [--recreate-lock-file] [--no-update-lock-file] [--no-write-lock-file] [--no-registries] [--commit-lock-file]++
	\[--update-input UPDATE_INPUT] [--override-input OVERRIDE_INPUT OVERRIDE_INPUT] [--no-build-output] [--use-substitutes] [--help] [--debug] [--file FILE] [--attr ATTR] [--flake [FLAKE]] [--no-flake] [--install-bootloader]++
	\[--profile-name PROFILE_NAME] [--specialisation SPECIALISATION] [--rollback] [--upgrade] [--upgrade-all] [--json] [--ask-sudo-password] [--sudo] [--no-reexec]++
	\[--build-host BUILD_HOST] [--target-host TARGET_HOST] [--no-build-nix] [--image-variant IMAGE_VARIANT]++
	\[{switch,boot,test,build,edit,repl,dry-build,dry-run,dry-activate,build-image,build-vm,build-vm-with-bootloader,list-generations}]

# DESCRIPTION

This command updates the system so that it corresponds to the configuration
specified in /etc/nixos/configuration.nix, /etc/nixos/flake.nix or the file and
attribute specified by the *--file* and/or *--attr* options. Thus, every
time you modify the configuration or any other NixOS module, you must run
*nixos-rebuild* to make the changes take effect. It builds the new system in
/nix/store, runs its activation script, and stop and (re)starts any system
services if needed. Please note that user services need to be started manually
as they aren't detected by the activation script at the moment.

This command has one required argument, which specifies the desired operation.
It must be one of the following:

*switch*
	Build and activate the new configuration, and make it the boot default.
	That is, the configuration is added to the GRUB boot menu as the
	default menu entry, so that subsequent reboots will boot the system
	into the new configuration. Previous configurations activated with
	nixos-rebuild switch or nixos-rebuild boot remain available in the GRUB
	menu.

	Note that if you are using specializations, running just nixos-rebuild
	switch will switch you back to the unspecialized, base system — in that
	case, you might want to use this instead:

		$ nixos-rebuild switch --specialisation your-specialisation-name

	This command will build all specialisations and make them bootable
	just like regular nixos-rebuild switch does — the only thing different
	is that it will switch to given specialisation instead of the base
	system; it can be also used to switch from the base system into a
	specialised one, or to switch between specialisations.

*boot*
	Build the new configuration and make it the boot default (as with
	*nixos-rebuild switch*), but do not activate it. That is, the system
	continues to run the previous configuration until the next reboot.

*test*
	Build and activate the new configuration, but do not add it to the GRUB
	boot menu. Thus, if you reboot the system (or if it crashes), you will
	automatically revert to the default configuration (i.e. the
	configuration resulting from the last call to *nixos-rebuild switch* or
	*nixos-rebuild boot*).

	Note that if you are using specialisations, running just nixos-rebuild
	test will activate the unspecialised, base system — in that case, you
	might want to use this instead:

		$ nixos-rebuild test --specialisation your-specialisation-name

	This command can be also used to switch from the base system into a
	specialised one, or to switch between specialisations.

*build*
	Build the new configuration, but neither activate it nor add it to the
	GRUB boot menu. It leaves a symlink named result in the current
	directory, which points to the output of the top-level “system”
	derivation. This is essentially the same as doing

		$ nix-build /path/to/nixpkgs/nixos -A system

	Note that you do not need to be root to run *nixos-rebuild build*.

*dry-build*
	Show what store paths would be built or downloaded by any of the
	operations above, but otherwise do nothing.

*dry-activate*
	Build the new configuration, but instead of activating it, show what
	changes would be performed by the activation (i.e. by *nixos-rebuild*
	test). For instance, this command will print which systemd units would be
	restarted. The list of changes is not guaranteed to be complete.

*edit*
	Opens _configuration.nix_ in the default editor.

*repl*
	Opens the configuration in *nix repl*.

*build-image*
	Build a disk-image variant, pre-configured for the given
	platform/provider. Select a variant with the *--image-variant* option
	or run without any options to get a list of available variants.

		$ nixos-rebuild build-image --image-variant proxmox

*build-vm*
	Build a script that starts a NixOS virtual machine with the desired
	configuration. It leaves a symlink _result_ in the current directory that
	points (under ‘result/bin/run-_hostname_-vm’) at the script that starts
	the VM. Thus, to test a NixOS configuration in a virtual machine, you
	should do the following:

		$ nixos-rebuild build-vm && ./result/bin/run-\*-vm

	The VM is implemented using the ‘qemu’ package. For best performance, you
	should load the ‘kvm-intel’ or ‘kvm-amd’ kernel modules to get hardware
	virtualisation.

	The VM mounts the Nix store of the host through the 9P file system. The
	host Nix store is read-only, so Nix commands that modify the Nix store
	will not work in the VM. This includes commands such as *nixos-rebuild*;
	to change the VM’s configuration, you must halt the VM and re-run the
	commands above.

	The VM has its own ext3 root file system, which is automatically created
	when the VM is first started, and is persistent across reboots of the VM.
	It is stored in ‘./_hostname_.qcow2’.

*build-vm-with-bootloader*
	Like build-vm, but boots using the regular boot loader of your
	configuration (e.g. GRUB 1 or 2), rather than booting directly into the
	kernel and initial ramdisk of the system. This al‐ lows you to test
	whether the boot loader works correctly. However, it does not guarantee
	that your NixOS configuration will boot successfully on the host
	hardware (i.e., after running *nixos-rebuild switch*), because the
	hardware and boot loader configuration in the VM are different. The boot
	loader is installed on an automatically generated virtual disk
	containing a /boot partition.

*list-generations [--json]*
	List the available generations in a similar manner to the boot loader
	menu. It shows the generation number, build date and time, NixOS
	version, kernel version and the configuration revi‐ sion. There is also
	a json version of output available.

# OPTIONS

*--upgrade, --upgrade-all*
	Update the root user's channel named ‘nixos’ before rebuilding the
	system.

	In addition to the ‘nixos’ channel, the root user's channels which have
	a file named ‘.update-on-nixos-rebuild’ in their base directory will
	also be updated.

	Passing *--upgrade-all* updates all of the root user's channels.

*--install-bootloader*
	Causes the boot loader to be (re)installed on the device specified by
	the relevant configuration options.

*--no-reexec*
	Normally, *nixos-rebuild* first finds and builds itself from the
	_config.system.build.nixos-rebuild_ attribute from the current user
	channel or flake and exec into it. This allows *nixos-rebuild* to run
	with the latest bug-fixes. This option disables it, using the current
	*nixos-rebuild* instance instead.

*--rollback*
	Instead of building a new configuration as specified by
	_/etc/nixos/configuration.nix_, roll back to the previous configuration.
	(The previous configuration is defined as the one before the “current”
	generation of the Nix profile _/nix/var/nix/profiles/system_.)

*--builders* _builder-spec_
	Allow ad-hoc remote builders for building the new system. This requires
	the user executing *nixos-rebuild* (usually root) to be configured as a
	trusted user in the Nix daemon. This can be achieved by using the
	_nix.settings.trusted-users_ NixOS option. Examples values for that
	option are described in the “Remote builds” chapter in the Nix manual,
	(i.e. ‘--builders "ssh://bigbrother x86_64-linux"’). By specifying an
	empty string existing builders specified in /etc/nix/machines can be
	ignored: ‘--builders ""’ for example when they are not reachable due to
	network connectivity.

*--profile-name* _name_, *-p* _name_
	Instead of using the Nix profile _/nix/var/nix/profiles/system_ to keep
	track of the current and previous system configurations, use
	_/nix/var/nix/profiles/system-profiles/name_. When you use GRUB 2, for
	every system profile created with this flag, NixOS will create a submenu
	named “NixOS - Profile _name_” in GRUB's boot menu, containing the
	current and previous configurations of this profile.

	For instance, if you want to test a configuration file named _test.nix_
	without affecting the default system profile, you would do:

		$ nixos-rebuild switch -p test -I nixos-config=./test.nix

	The new configuration will appear in the GRUB 2 submenu “NixOS - Profile
	‘test’”.

*--specialisation* _name_, *-c* _name_
	Activates given specialisation; when not specified, switching and testing
	will activate the base, unspecialised system.

*--image-variant* _variant_
	Selects an image variant to build from the _config.system.build.images_
	attribute of the given configuration. A list of variants is printed if
	this option remains unset.

*--build-host* _host_
	Instead of building the new configuration locally, use the specified host
	to perform the build. The host needs to be accessible with ssh, and must
	be able to perform Nix builds. If the option *--target-host* is not set,
	the build will be copied back to the local machine when done.

	You can include a remote user name in the host name (_user@host_). You
	can also set ssh options by defining the NIX_SSHOPTS environment
	variable.

*--target-host* _host_
	Specifies the NixOS target host. By setting this to something other than
	an empty string, the system activation will happen on the remote host
	instead of the local machine. The remote host needs to be accessible
	over *ssh*, and for the commands *switch*, *boot* and *test* you need
	root access.

	If *--build-host* is not explicitly specified or empty, building will
	take place locally.

	You can include a remote user name in the host name (_user@host_). You
	can also set ssh options by defining the NIX_SSHOPTS environment
	variable.

	Note that *nixos-rebuild* honors the _nixpkgs.crossSystem_ setting of
	the given configuration but disregards the true architecture of the
	target host. Hence the _nixpkgs.crossSystem_ setting has to match the
	target platform or else activation will fail.

*--use-substitutes*
	When set, nixos-rebuild will add *--use-substitutes* to each invocation
	of _nix copy_. This will only affect the behavior of nixos-rebuild if
	*--target-host* or *--build-host* is also set. This is useful when the
	target-host connection to cache.nixos.org is faster than the connection
	between hosts.

*--sudo*
	When set, *nixos-rebuild* prefixes activation commands with sudo.
	Setting this option allows deploying as a non-root user.

*--ask-sudo-password*, *-S*
	When set, *nixos-rebuild* will ask for sudo password for remote
	activation (i.e.: on *--target-host*) at the start of the build process.
	Implies *--sudo*.

*--file* _path_, *-f* _path_
	Enable and build the NixOS system from the specified file. The file must
	evaluate to an attribute set, and it must contain a valid NixOS
	configuration at attribute _attrPath_. This is useful for building a
	NixOS system from a nix file that is not a flake or a NixOS
	configuration module. Attribute set a with valid NixOS configuration can
	be made using _nixos_ function in nixpkgs or importing and calling
	nixos/lib/eval-config.nix from nixpkgs. If specified without *--attr*
	option, builds the configuration from the top-level attribute of the
	file.

*--attr* _attrPath_, *-A* _attrPath_
	Enable and build the NixOS system from nix file and use the specified
	attribute path from file specified by the *--file* option. If specified
	without *--file* option, uses _default.nix_ in current directory.

*--flake* _flake-uri[#name]_, *-F* _flake-uri[#name]_
	Build the NixOS system from the specified flake. It defaults to the
	directory containing the target of the symlink _/etc/nixos/flake.nix_,
	if it exists. The flake must contain an output named
	‘nixosConfigurations.name’. If name is omitted, it default to the
	current host name.

*--no-flake*
	Do not imply *--flake* if _/etc/nixos/flake.nix exists_. With this
	option, it is possible to build non-flake NixOS configurations even if
	the current NixOS systems uses flakes.

In addition, *nixos-rebuild* accepts following options from nix commands that
the tool calls:

Flake-related options:

*--accept-flake-config*, *--refresh*, *--impure*, *--offline*, *--no-net*
*--recreate-lock-file*, *--no-update-lock-file*, *--no-write-lock-file*,
*--no-registries*, *--commit-lock-file*, *--update-input* _input-path_,
*--override-input* _input-path_ _flake-url_

Builder options:

*--verbose,*  *-v*,  *--quiet*,  *--log-format*,  *--no-build-output*, *-Q*,
*--no-link*, *--max-jobs*, *-j*, *--cores*, *--keep-going*, *-k*,
*--keep-failed*, *-K*, *--fallback*, *--include*, *-I*, *--option*, *--repair*,
*--builders*, *--print-build-logs*, *-L*, *--show-trace*

See the Nix manual, *nix flake lock --help* or *nix-build --help* for details.

# ENVIRONMENT

NIXOS_CONFIG
	Path to the main NixOS configuration module. Defaults to
	_/etc/nixos/configuration.nix_.

NIX_PATH
	A colon-separated list of directories used to look up Nix expressions
	enclosed in angle brackets (e.g. <nixpkgs>). Example:

		nixpkgs=./my-nixpkgs

NIX_SSHOPTS
	Additional options to be passed to ssh on the command line.

# FILES

/etc/nixos/flake.nix
	If this file exists, then *nixos-rebuild* will use it as if the
	*--flake* option was given. This file may be a symlink to a
	flake.nix in an actual flake; thus _/etc/nixos_ need not be a
	flake.

/run/current-system
	A symlink to the currently active system configuration in the
	Nix store.

/nix/var/nix/profiles/system
	The Nix profile that contains the current and previous system
	configurations. Used to generate the GRUB boot menu.

# AUTHORS

Nixpkgs/NixOS contributors

; vim: set noet
