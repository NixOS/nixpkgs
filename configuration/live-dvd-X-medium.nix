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

	extraInitrdKernelModules = 
		import ./moduleList.nix;

	arbitraryOverrides = config : config // {
		services = config.services // {
			gw6c = {
				enable = true;
				autorun = false;
			};
		};
	};

	packages = pkgs : [
		pkgs.irssi
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
		pkgs.gnumake
		pkgs.manpages
		pkgs.cabextract
		pkgs.upstartJobControl
		pkgs.fpc
		pkgs.perl
		pkgs.lftp
		pkgs.wget
		pkgs.utillinuxCurses
		pkgs.iproute
		pkgs.diffutils
		pkgs.pciutils
		pkgs.lsof
		pkgs.vimHugeX
		pkgs.xpdf
		pkgs.ghostscript
		pkgs.gv
		pkgs.firefoxWrapper
		pkgs.xlaunch
		pkgs.wirelesstools
		pkgs.usbutils
		pkgs.dmidecode
		(theKernel pkgs)
		pkgs.sshfsFuse
		pkgs.ratpoison
		pkgs.xorg.twm
		pkgs.binutils
		pkgs.xorg.lndir
		pkgs.pstree
		pkgs.psmisc
		pkgs.aspell
		pkgs.gettext
		pkgs.xorg.xorgserver
		pkgs.xorg.xsetroot
		pkgs.xorg.xhost
		pkgs.xorg.xwd
		pkgs.xorg.xfontsel
		pkgs.xorg.xwud
		pkgs.xlaunch
		pkgs.xsel
		pkgs.xorg.xmessage
		pkgs.xorg.xauth
		pkgs.keynav
		pkgs.xorg.xset
		pkgs.xterm
		pkgs.xmove
		pkgs.xorg.xev
		pkgs.xorg.xmodmap
		pkgs.xorg.xkbcomp
		pkgs.xorg.setxkbmap
		pkgs.mssys
		pkgs.testdisk
		pkgs.gdb
		pkgs.pidgin
		pkgs.pidginotr
		pkgs.gdmap
		pkgs.thunderbird
		pkgs.wv
		pkgs.tightvnc
		pkgs.bittornado
		pkgs.wireshark
		pkgs.smbfsFuse
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
        {
                suffix = "X-NVIDIA";
                configuration = (configuration //
                {
                        boot=configuration.boot // {configurationName = "X with NVIDIA graphic card";};
                        services = configuration.services // {
                                xserver = xConfiguration // {videoDriver = "nvidia"; driSupport = true;};
                        };
                });
        }
	];
}).rescueCD
