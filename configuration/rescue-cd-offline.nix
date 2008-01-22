{platform ? __currentSystem} : 
let 
  isoFun = import ./rescue-cd-configurable.nix;
in 
(isoFun {
	inherit platform;
	lib = (import ../pkgs/lib);

	networkNixpkgs = "";
	manualEnabled = false;
	rogueEnabled = false;
	sshdEnabled = false;
	fontConfigEnabled = false;
	sudoEnable = false;
	includeMemtest = false;
	includeStdenv = false;
	includeBuildDeps = true;
	cleanStart = true;
	packages = pkgs: with pkgs; [
		bashInteractive
		bzip2
		coreutils
		curl
		e2fsprogs
		gnutar
		grub
		gzip
		less
		module_init_tools
		nano
		su
		udev
		upstart
		utillinux
	];
}).rescueCD
