{platform ? __currentSystem} : 
let 
  isoFun = import ./rescue-cd-configurable.nix;
  xResolutions = [
  	{ x = 2048; y = 1536; }
	{ x = 1920; y = 1024; }
  	{ x = 1280; y = 800; }
  	{ x = 1024; y = 768; }
  	{ x = 800; y = 600; }
  	{ x = 640; y = 480; }
  ];
  xConfiguration = {
	enable = true;
	exportConfiguration = true;
	tcpEnable = true;
	resolutions = xResolutions;
	sessionType = "xterm";
	windowManager = "twm";
	tty = "9";
  };

  theKernel = pkgs: let baseKernel=pkgs.kernel; 
	in (pkgs.module_aggregation 
    		[
		baseKernel
		(pkgs.kqemuFunCurrent baseKernel)
		(pkgs.atherosFun {
			kernel = baseKernel;
			version = "r2756";
			pci001c_rev01 = true;
		} null)
		]);


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
	addUsers = ["nixos" "livecd" "livedvd" 
		"user" "guest" "nix"];

	kernel = pkgs: (
		pkgs.module_aggregation 
		[pkgs.kernel]
	);
	extraInitrdKernelModules = [
		# The initrd should contain any modules necessary for
		# mounting the CD.

		# SATA/PATA support.
		"ahci"
		
		"ata_piix"
		
		"sata_inic162x" "sata_nv" "sata_promise" "sata_qstor"
		"sata_sil" "sata_sil24" "sata_sis" "sata_svw" "sata_sx4"
		"sata_uli" "sata_via" "sata_vsc"
		
		"pata_ali" "pata_amd" "pata_artop" "pata_atiixp"
		"pata_cs5520" "pata_cs5530" "pata_cs5535" "pata_efar"
		"pata_hpt366" "pata_hpt37x" "pata_hpt3x2n" "pata_hpt3x3"
		"pata_it8213" "pata_it821x" "pata_jmicron" "pata_marvell"
		"pata_mpiix" "pata_netcell" "pata_ns87410" "pata_oldpiix"
		"pata_pcmcia" "pata_pdc2027x" "pata_qdi" "pata_rz1000"
		"pata_sc1200" "pata_serverworks" "pata_sil680" "pata_sis"
		"pata_sl82c105" "pata_triflex" "pata_via"
		# "pata_winbond" <-- causes timeouts in sd_mod

		# SCSI support (incomplete).
		"3w-9xxx" "3w-xxxx" "aic79xx" "aic7xxx" "arcmsr" 

		# USB support, especially for booting from USB CD-ROM
		# drives.	Also include USB keyboard support for when
		# something goes wrong in stage 1.
		"ehci_hcd"
		"ohci_hcd"
		"usbhid"
		"usb_storage"

		# Firewire support.	Not tested.
		"ohci1394" "sbp2"

		# Wait for SCSI devices to appear.
		"scsi_wait_scan"

		# Needed for live-CD operation.
		"aufs"
	];

	packages = pkgs : [
		pkgs.which
		pkgs.file
		pkgs.zip
		pkgs.unzip
		pkgs.unrar
		pkgs.db4
		pkgs.attr
		pkgs.acl
		pkgs.manpages
		pkgs.cabextract
		pkgs.upstartJobControl
		pkgs.utillinuxCurses
		pkgs.emacs
		pkgs.lsof
		pkgs.vimHugeX
		pkgs.firefoxWrapper
		pkgs.xlaunch
		pkgs.ratpoison
		pkgs.xorg.twm
		pkgs.xorg.xorgserver
		pkgs.xorg.xhost
		pkgs.xorg.xfontsel
		pkgs.xlaunch
		pkgs.xorg.xauth
		pkgs.xorg.xset
		pkgs.xterm
		pkgs.xorg.xev
		pkgs.xorg.xmodmap
		pkgs.xorg.xkbcomp
		pkgs.xorg.setxkbmap
		pkgs.mssys
		pkgs.testdisk
		pkgs.gdb
	];

	configList = configuration : [
	{
		suffix = "X-vesa";
		configuration = (configuration // 
		{
			boot=configuration.boot // {configurationName = "X with vesa";};
			services = configuration.services // {
				xserver = xConfiguration // {videoDriver = "vesa";};
			};
		});
	}
	{
		suffix = "X-Intel";
		configuration = (configuration // 
		{
			boot=configuration.boot // {configurationName = "X with Intel graphic card";};
			services = configuration.services // {
				xserver = xConfiguration // {videoDriver = "intel"; driSupport = true;};
			};
		});
	}
	{
		suffix = "X-ATI";
		configuration = (configuration // 
		{
			boot=configuration.boot // {configurationName = "X with ATI graphic card";};
			services = configuration.services // {
				xserver = xConfiguration // {videoDriver = "ati"; driSupport = true;};
			};
		});
	}
	];
}).rescueCD
