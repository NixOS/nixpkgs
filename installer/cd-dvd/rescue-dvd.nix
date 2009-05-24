let 
  rescueCDFun = import ./rescue-cd.nix;
  pkgs = import ../../../nixpkgs {};
  kernels = import ../../../configurations/misc/raskin/kernel-options.nix {inherit pkgs;};
  bootEntries = baseKernel: rec {
    kernelPackages = let 
      shippedKernelPackages = pkgs.kernelPackagesFor (baseKernel);
    in
    shippedKernelPackages //
      rec { 
          klibc = shippedKernelPackages.klibc.passthru.function (x: {
            # version = "1.5.14";
            # sha256 = "1cmrqpgamnv2ns7dlxjm61zc88dxm4ff0aya413ij1lmhp2h2sfc";
            # subdir = "Testing/";
            addPreBuild = ''
              ln -s $PWD/linux/include/*/errno.h linux/include/asm || echo errno.h already present
            '';
          });
          
          klibcShrunk = shippedKernelPackages.klibcShrunk.passthru.function {
            inherit klibc;
          };
      };
    
  };
in 

rescueCDFun {
  includeBuildDeps = true;
  configurationOverrides = x: {
    boot = x.boot // {
      kernelPackages = (bootEntries kernels.testingKernel).kernelPackages;
      initrd = x.boot.initrd // {
        extraKernelModules = x.boot.initrd.extraKernelModules ++ [
          "sr_mod" "atiixp"
        ];
	allowMissing = true;
      };
    };
    environment = {
      extraPackages = x.environment.extraPackages ++ [
        pkgs.utillinuxCurses pkgs.wpa_supplicant 
        pkgs.upstartJobControl pkgs.iproute
        pkgs.bc pkgs.fuse pkgs.zsh
        pkgs.sqlite pkgs.gnupg pkgs.manpages 
	pkgs.pinentry pkgs.screen

        pkgs.patch pkgs.which pkgs.diffutils pkgs.file 

        pkgs.irssi pkgs.mcabber pkgs.mutt 

        pkgs.emacs pkgs.vimHugeX pkgs.bvi 

        pkgs.ddrescue pkgs.cdrkit 

        pkgs.btrfsProgs pkgs.xfsProgs pkgs.jfsUtils
	pkgs.jfsrec pkgs.ntfs3g 

        pkgs.subversion16 pkgs.monotone pkgs.git pkgs.darcs
	pkgs.mercurial pkgs.bazaar pkgs.cvs 
	
	pkgs.pciutils pkgs.hddtemp pkgs.sdparm pkgs.hdparm 
	pkgs.usbutils 

	pkgs.openssh pkgs.lftp pkgs.w3m pkgs.openssl pkgs.ncat 
	pkgs.lynx pkgs.wget pkgs.elinks pkgs.socat pkgs.squid
        
        pkgs.unrar pkgs.zip pkgs.unzip pkgs.lzma pkgs.cabextract 
	pkgs.cpio 

        pkgs.lsof pkgs.ltrace 

        pkgs.perl pkgs.python pkgs.ruby pkgs.guile pkgs.clisp
	pkgs.tcl
      ];

      nix = pkgs.nixCustomFun ("" + ../../../nix + "/")
          ""
          ["nix-reduce-build" "nix-http-export.cgi"]
          ["--with-docbook-xsl=${pkgs.docbook5_xsl}/xml/xsl/docbook/"];
    };

#    nesting = {
#      children = [
#        (x // {
#          boot = x.boot // {
#            kernelPackages = (bootEntries kernels.testingKernel).kernelPackages;
#            configurationName = "Test child configuration";
#          };
#        })
#      ];
#    };
  };
}
