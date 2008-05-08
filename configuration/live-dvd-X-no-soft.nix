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
	in (pkgs.aggregateModules 
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
		pkgs.aggregateModules 
		[pkgs.kernel]
	);
	extraInitrdKernelModules = 
		import ./moduleList.nix;

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
