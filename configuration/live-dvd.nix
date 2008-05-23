{platform ? __currentSystem} : 
let 
  isoFun = import ./rescue-cd-configurable.nix;
in 
(isoFun {
	inherit platform;
	lib = (import ../pkgs/lib);

	networkNixpkgs = "";
	manualEnabled = true;
	rogueEnabled = true;
	sshdEnabled = true;
	fontConfigEnabled = true;
	sudoEnable = true;
	includeMemtest = true;
	includeStdenv = true;
	includeBuildDeps = true;

	packages = pkgs : [
		pkgs.irssi
		pkgs.elinks
		pkgs.ltrace
		pkgs.subversion
		pkgs.which
		pkgs.file
		pkgs.zip
		pkgs.unzip
		pkgs.unrar
		pkgs.usbutils
		pkgs.bc
		pkgs.cpio
		pkgs.ncat
		pkgs.patch
		pkgs.fuse
		pkgs.indent
		pkgs.zsh
		pkgs.hddtemp
		pkgs.hdparm
		pkgs.sdparm
		pkgs.sqlite
		pkgs.wpa_supplicant
		pkgs.lynx
		pkgs.db4
		pkgs.rogue
		pkgs.attr
		pkgs.acl
		pkgs.automake
		pkgs.autoconf
		pkgs.libtool
		pkgs.gnupg
		pkgs.openssl
		pkgs.units
		pkgs.gnumake
		pkgs.manpages
		pkgs.cabextract
		pkgs.upstartJobControl
		pkgs.fpc
		pkgs.python
		pkgs.perl
		pkgs.lftp
		pkgs.wget
		pkgs.guile
		pkgs.utillinuxCurses
		pkgs.emacs
		pkgs.iproute
		pkgs.MPlayer
		pkgs.diffutils
		pkgs.pciutils
		pkgs.lsof
		pkgs.vimHugeX
	];
}).rescueCD
