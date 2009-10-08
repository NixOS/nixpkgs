{config, pkgs, ...}:

{
  require = [./installation-cd.nix];

  # Build the build-time dependencies of this configuration on the DVD
  # to speed up installation.
  isoImage.storeContents = [config.system.build.toplevel.drvPath];

  # Include lots of packages.
  environment.systemPackages =
    [ pkgs.utillinuxCurses
      pkgs.wpa_supplicant 
      pkgs.upstartJobControl
      pkgs.iproute
      pkgs.bc
      pkgs.fuse
      pkgs.zsh
      pkgs.sqlite
      pkgs.gnupg
      pkgs.manpages
      pkgs.pinentry
      pkgs.screen
      pkgs.patch
      pkgs.which
      pkgs.diffutils
      pkgs.file 
      pkgs.irssi
      pkgs.mcabber
      pkgs.mutt 
      pkgs.emacs
      pkgs.vimHugeX
      pkgs.bvi 
      pkgs.ddrescue
      pkgs.cdrkit 
      pkgs.btrfsProgs
      pkgs.xfsprogs
      pkgs.jfsutils
      pkgs.jfsrec
      pkgs.ntfs3g 
      pkgs.subversion16
      pkgs.monotone
      pkgs.git
      pkgs.darcs
      pkgs.mercurial
      pkgs.bazaar
      pkgs.cvs 
      pkgs.pciutils
      pkgs.hddtemp
      pkgs.sdparm
      pkgs.hdparm
      pkgs.usbutils 
      pkgs.openssh
      pkgs.lftp
      pkgs.w3m
      pkgs.openssl
      pkgs.ncat
      pkgs.lynx
      pkgs.wget
      pkgs.elinks
      pkgs.socat
      pkgs.squid
      pkgs.unrar
      pkgs.zip
      pkgs.unzip
      pkgs.lzma
      pkgs.cabextract
      pkgs.cpio 
      pkgs.lsof
      pkgs.ltrace 
      pkgs.perl
      pkgs.python
      pkgs.ruby
      pkgs.guile
      pkgs.clisp
      pkgs.tcl
    ];
  
}
