{
   lib ? null
  ,platform ? __currentSystem
  ,networkNixpkgs ? ""
  ,nixpkgsMd5 ? ""
  ,manualEnabled ? true
  ,rogueEnabled ? true
  ,sshdEnabled ? false
  ,fontConfigEnabled ? false
  ,sudoEnable ? false
  ,packages ? (pkgs : [])
  ,includeMemtest ? true
  ,includeStdenv ? true
  ,includeBuildDeps ? false
  ,kernelPackages ? (pkgs : pkgs.kernelPackages)
  ,extraModulePackages ? (pkgs : [])
  ,addUsers ? []
  ,extraInitrdKernelModules ? []
  ,bootKernelModules ? []
  ,arbitraryOverrides ? (config:{})
  ,cleanStart ? false

   /* Should return list of {configuration, suffix} attrsets.
   {configuration=configuration; suffix=""} is always prepended.
   */
  ,configList ? (configuration : [])
  ,aufs ? true

  /*
  	Address/netmask to be always added, whatever 
	network-interfaces configure is kept
  */
  ,addIP ? ""
  ,netmask ? "255.255.255.0"
  /* To select interface to bind address to */
  ,ifName ? "eth0"

  /* 
  	list of: {source, target}
  */
  ,additionalFiles ? []
  ,compressImage ? false
  ,nixpkgsPath ? ../../../nixpkgs
  ,additionalJobs ? []
  ,intel3945FWEnable ? true
  ,intel4965FWEnable ? true
  ,cdLabel ? "NIXOS_INSTALLATION_CD"
  ,relName ?
    if builtins.pathExists ../../relname
    then builtins.readFile ../../relname
    else "nixos-${builtins.readFile ../../VERSION}"
  ,nix ? pkgs: pkgs.nix
}:
let 
  realLib = if lib != null then lib else (import (nixpkgsPath+"/pkgs/lib"));
in
let
  lib = realLib;

  ttyCount = lib.fold builtins.add 0 [
    (if rogueEnabled then 1 else 0)
    (if manualEnabled then 1 else 0)
  ];
 
  systemPackBuilder = {suffix, configuration} : 
  { 
    system = (import ../../system/system.nix) {
      inherit configuration platform nixpkgsPath; /* To refactor later - x86+x86_64 DVD */
    };
    inherit suffix configuration;
  };
 
  systemPackGrubEntry = systemPack : 
  (''

      title NixOS Installer / Rescue ${systemPack.system.config.boot.configurationName}
      kernel /boot/vmlinuz${systemPack.suffix} ${toString systemPack.system.config.boot.kernelParams} systemConfig=/system${systemPack.suffix}
      initrd /boot/initrd${systemPack.suffix}
 
  '');
 
  systemPackInstallRootList = systemPack : 
  [
    { 
      source = systemPack.system.kernel + "/vmlinuz";
      target = "boot/vmlinuz${systemPack.suffix}";
    }
    { 
      source = systemPack.system.initialRamdisk + "/initrd";
      target = "boot/initrd${systemPack.suffix}";
    }
  ];
  systemPackInstallClosures = systemPack : 
  ([
    { 
      object = systemPack.system.bootStage2;
      symlink = "/init${systemPack.suffix}";
    }
    { 
      object = systemPack.system.system;
      symlink = "/system${systemPack.suffix}";
    }
  ]
  ++
  (lib.optional includeStdenv 
  # To speed up the installation, provide the full stdenv.
    { 
      object = systemPack.system.pkgs.stdenv;
      symlink = "none";
    }
  )
  );
  systemPackInstallBuildClosure = systemPack : 
  ([
    {
      object = systemPack.system.system.drvPath;
      symlink = "none";
    }
  ]);
 
 
  userEntry = user : 
  {
    name = user;
    description = "NixOS Live Disk non-root user";
    home = "/home/${user}";
    createHome = true;
    group = "users";
    extraGroups = ["wheel" "audio"];
    shell = "/bin/sh";
  };
in

rec {

  inherit cdLabel;

  nixpkgsRel = "nixpkgs" + (if networkNixpkgs != "" then "-" + networkNixpkgs else "");
 
  configuration = {pkgs, config, ...}: let preConfiguration ={
    boot = {
      isLiveCD = true;
      # The label used to identify the installation CD.
      extraTTYs = [] 
        ++ (lib.optional manualEnabled 7) 
        ++ (lib.optional rogueEnabled 8);
      kernelPackages = kernelPackages pkgs;
      initrd = {
      extraKernelModules = extraInitrdKernelModules
      ++ (if aufs then ["aufs"] else [])
      ;
      };
      kernelModules = bootKernelModules;
      extraModulePackages = ((extraModulePackages pkgs)
      ++(if aufs then [(kernelPackages pkgs).aufs] else [])
      );
    };
    
    services = {
      
      sshd = { enable = sshdEnabled; };
      
      xserver = { enable = false; };

      udev = {
        addFirmware = []
	  #++ (pkgs.lib.optional intel3945FWEnable pkgs.iwlwifi3945ucode)
	  #++ (pkgs.lib.optional intel4965FWEnable pkgs.iwlwifi4965ucode)
	  ;
      };
   
      extraJobs = [
        # Unpack the NixOS/Nixpkgs sources to /etc/nixos.
        { 
          name = "unpack-sources";
          job = ''
            start on startup
            script
            export PATH=${pkgs.gnutar}/bin:${pkgs.bzip2}/bin:$PATH

	    mkdir -p /mnt
        
            ${system.nix}/bin/nix-store --load-db < /nix-path-registration
        
            mkdir -p /etc/nixos/nixos
            tar xjf /install/nixos.tar.bz2 -C /etc/nixos/nixos
            tar xjf /install/nixpkgs.tar.bz2 -C /etc/nixos
	    tar xjf /install/nixos-services.tar.bz2 -C /etc/nixos
            mv /etc/nixos/nixpkgs-* /etc/nixos/nixpkgs || true
            mv /etc/nixos/*-nixpkgs /etc/nixos/nixpkgs || true
            mv /etc/nixos/*-services /etc/nixos/services || true
            ln -sfn ../nixpkgs/pkgs /etc/nixos/nixos/pkgs
            ln -sfn ../services /etc/nixos/services
            chown -R root.root /etc/nixos
            touch /etc/resolv.conf
            end script
          '';
        }
      ] 
        
      ++ additionalJobs

      ++ 
        
      (lib.optional manualEnabled 
        # Show the NixOS manual on tty7.
        { 
          name = "manual";
          job = ''
            start on udev
            stop on shutdown
            respawn ${pkgs.w3m}/bin/w3m ${manual} < /dev/tty7 > /dev/tty7 2>&1
          '';
        }
      )
       
      ++
       
      (lib.optional rogueEnabled
        # Allow the user to do something useful on tty8 while waiting
        # for the installation to finish.
        { 
          name = "rogue";
          job = ''
            start on udev
            stop on shutdown
            respawn ${pkgs.rogue}/bin/rogue < /dev/tty8 > /dev/tty8 2>&1
          '';
        }
      )
       
      ++
       
      (lib.optional (addUsers != [])
        # Set empty passwords
        {
          name = "clear-passwords";
          job = '' 
            start on startup
            script 
              for i in ${lib.concatStringsSep " " addUsers}; do
                  echo | ${pkgs.pwdutils}/bin/passwd --stdin $i
              done
            end script
          '';
        }
      )

      ++

      (lib.optional (addIP != "")
        {
	  name = "add-IP-adress";
	  job = ''
	    start on network-interfaces/started
	    script
	      ${pkgs.nettools}/sbin/ifconfig ${ifName} add ${addIP} up
	      ${pkgs.nettools}/sbin/ifconfig ${ifName}:0 netmask ${netmask} up 
	    end script
	  '';
	}
      )
      ;
       
      # And a background to go with that.
      ttyBackgrounds = {
        specificThemes = []
        ++
        (lib.optional manualEnabled
          { 
            tty = 7;
            # Theme is GPL according to http://kde-look.org/content/show.php/Green?content=58501.
            theme = pkgs.fetchurl {
              url = http://www.kde-look.org/CONTENT/content-files/58501-green.tar.gz;
              sha256 = "0sdykpziij1f3w4braq8r8nqg4lnsd7i7gi1k5d7c31m2q3b9a7r";
            };
          }
        )
        ++
        (lib.optional rogueEnabled 
          { 
            tty = 8;
            theme = pkgs.fetchurl {
              url = http://www.bootsplash.de/files/themes/Theme-GNU.tar.bz2;
              md5 = "61969309d23c631e57b0a311102ef034";
            };
          }
        )
        ;
      };
   
      mingetty = {
        helpLine = ''     
          Log in as "root" with an empty password. 
        ''
        +(if addUsers != [] then 
          '' These users also have empty passwords:
            ${lib.concatStringsSep " " addUsers }
          '' 
        else "")
        +(if manualEnabled then " Press <Alt-F7> for help." else "");
      };
      
    };
  
    fonts = { enableFontConfig = fontConfigEnabled; };
    
    installer = {
      nixpkgsURL = 
        (if networkNixpkgs != "" then http://nix.cs.uu.nl/dist/nix/ + nixpkgsRel
          else file:///mnt/ );
    };
  
    security = {
      sudo = { enable = sudoEnable; };
    };
    
    environment = {
      extraPackages = if cleanStart then [] else [
        pkgs.vim
        pkgs.subversion # for nixos-checkout
        pkgs.w3m # needed for the manual anyway
      ] ++ (packages pkgs);
      checkConfigurationOptions = true;
      cleanStart = cleanStart;
      nix = nix pkgs;
    };
  
    users = {
      extraUsers = map userEntry addUsers;
    };
    
    fileSystems = [
      { mountPoint = "/";
        label = cdLabel;
      }
    ];
    
  }; in preConfiguration // (arbitraryOverrides preConfiguration);
 
  configurations = [{
    inherit configuration;
    suffix = "";
  }] ++ (configList configuration);
  systemPacks = map systemPackBuilder configurations;
 
  system = (builtins.head systemPacks).system; /* I hope this is unneeded */
  pkgs = system.pkgs; /* Nothing non-fixed should be built from it */
 
 
  # The NixOS manual, with a backward compatibility hack for Nix <=
  # 0.11 (you won't get the manual).
  manual = if builtins ? unsafeDiscardStringContext
    then "${import ../../doc/manual {inherit nixpkgsPath;}}/manual.html"
    else pkgs.writeText "dummy-manual" "Manual not included in this build!";
 
 
  # We need a copy of the Nix expressions for Nixpkgs and NixOS on the
  # CD. We put them in a tarball because accessing that many small
  # files from a slow device like a CD-ROM takes too long.
  makeTarball = tarName: input: pkgs.runCommand "tarball" {inherit tarName;} ''
    ensureDir $out
    (cd ${input} && tar cvfj $out/${tarName} . \
        --exclude '*~' \
        --exclude 'pkgs' --exclude 'result')
  '';
 
  makeNixPkgsTarball = tarName: input: ((pkgs.runCommand "tarball-nixpkgs" {inherit tarName;} ''
  ensureDir $out
    (cd ${input}/.. && tar cvfj $out/${tarName} $(basename ${input}) \
        --exclude '*~' \
        --exclude 'result')
  '')+"/${tarName}");
 
 
  
  # Put the current directory in a tarball (making sure to filter
  # out crap like the .svn directories).
  nixosTarball =
    let filter = name: type:
    let base = baseNameOf (toString name);
    in base != ".svn" && base != "result";
    in
    makeTarball "nixos.tar.bz2" (builtins.filterSource filter ./../..);
 
 
  # Get a recent copy of Nixpkgs.
  nixpkgsTarball = if networkNixpkgs != "" then pkgs.fetchurl {
    url = configuration.installer.nixpkgsURL + "/" + nixpkgsRel + ".tar.bz2";
    md5 = "6a793b877e2a4fa79827515902e1dfd8";
  } else makeNixPkgsTarball "nixpkgs.tar.bz2" ("" + nixpkgsPath);

  nixosServicesTarball = makeNixPkgsTarball "nixos-services.tar.bz2" ("" + ./../../../services);
 
  # The configuration file for Grub.
  grubCfg = pkgs.writeText "menu.lst" (''
    default 0
    timeout 10
    splashimage /boot/background.xpm.gz
  ''+
  (lib.concatStrings (map systemPackGrubEntry systemPacks))
  + (if includeMemtest then
  ''
 
    title Memtest86+
    kernel /boot/memtest.bin
  '' else ""));
 
 
  # Create an ISO image containing the Grub boot loader, the kernel,
  # the initrd produced above, and the closure of the stage 2 init.
  rescueCD = import ../../helpers/make-iso9660-image.nix {
    inherit (pkgs) stdenv perl cdrkit;
    inherit compressImage nixpkgsPath;
    isoName = "nixos-${relName}-${platform}.iso";
  
    # Single files to be copied to fixed locations on the CD.
    contents = lib.uniqList {
      inputList = [
        { 
          source = 
	    "${pkgs.grub}/lib/grub/${if platform == "i686-linux" then "i386-pc" else "x86_64-unknown"}/stage2_eltorito";
          target = "boot/grub/stage2_eltorito";
        }
        { 
          source = grubCfg;
          target = "boot/grub/menu.lst";
        }
      ]
      ++ 
      (lib.concatLists (map systemPackInstallRootList systemPacks))
      ++
      [
        { 
          source = system.config.boot.grubSplashImage;
          target = "boot/background.xpm.gz";
        }
        { 
          source = nixosTarball + "/" + nixosTarball.tarName;
          target = "/install/" + nixosTarball.tarName;
        }
        {
          source = nixpkgsTarball;
          target = "/install/nixpkgs.tar.bz2";
        }
        {
          source = nixosServicesTarball;
          target = "/install/nixos-services.tar.bz2";
        }
      ]
      ++
      (lib.optional includeMemtest 
        { 
          source = pkgs.memtest86 + "/memtest.bin";
          target = "boot/memtest.bin";
        }
      )
      ++
      additionalFiles
      ;
    };
  
    # Closures to be copied to the Nix store on the CD.
    storeContents = lib.uniqListExt {
      inputList= lib.concatLists 
        (map systemPackInstallClosures systemPacks);
      getter = x : x.object.drvPath;
      compare = lib.eqStrings;
    };
  
    buildStoreContents = lib.uniqList 
    {
      inputList=([]
      ++
      (if includeBuildDeps then lib.concatLists 
        (map systemPackInstallBuildClosure systemPacks)
      else [])
      );
    };
    
    bootable = true;
    bootImage = "boot/grub/stage2_eltorito";
    
    volumeID = cdLabel;
  };
 
}
