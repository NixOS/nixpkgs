with import ../lib;

{ nixpkgs ? { outPath = cleanSource ./..; revCount = 130979; shortRev = "gfedcba"; }
, stableBranch ? false
, supportedSystems ? [ "x86_64-linux" "aarch64-linux" ]
, configuration ? {}
}:

with import ../pkgs/top-level/release-lib.nix { inherit supportedSystems; };

let

  version = fileContents ../.version;
  versionSuffix =
    (if stableBranch then "." else "pre") + "${toString nixpkgs.revCount}.${nixpkgs.shortRev}";

  # Run the tests for each platform.  You can run a test by doing
  # e.g. ‘nix-build release.nix -A tests.login.x86_64-linux’,
  # or equivalently, ‘nix-build tests/login.nix’.
  # See also nixosTests in pkgs/top-level/all-packages.nix
  allTestsForSystem = system:
    import ./tests/all-tests.nix {
      inherit system;
      pkgs = import ./.. { inherit system; };
      callTest = t: {
        ${system} = hydraJob t.test;
      };
    } // {
      # for typechecking of the scripts and evaluation of
      # the nodes, without running VMs.
      allDrivers =
        import ./tests/all-tests.nix {
        inherit system;
        pkgs = import ./.. { inherit system; };
        callTest = t: {
          ${system} = hydraJob t.test.driver;
        };
      };
    };

  allTests =
    foldAttrs recursiveUpdate {} (map allTestsForSystem supportedSystems);

  pkgs = import ./.. { system = "x86_64-linux"; };


  versionModule =
    { system.nixos.versionSuffix = versionSuffix;
      system.nixos.revision = nixpkgs.rev or nixpkgs.shortRev;
    };

  makeModules = module: rest: [ configuration versionModule module rest ];

  makeIso =
    { module, type, system, ... }:

    with import ./.. { inherit system; };

    hydraJob ((import lib/eval-config.nix {
      inherit system;
      modules = makeModules module {
        isoImage.isoBaseName = "nixos-${type}";
      };
    }).config.system.build.isoImage);


  makeSdImage =
    { module, system, ... }:

    with import ./.. { inherit system; };

    hydraJob ((import lib/eval-config.nix {
      inherit system;
      modules = makeModules module {};
    }).config.system.build.sdImage);


  makeSystemTarball =
    { module, maintainers ? ["viric"], system }:

    with import ./.. { inherit system; };

    let

      config = (import lib/eval-config.nix {
        inherit system;
        modules = makeModules module {};
      }).config;

      tarball = config.system.build.tarball;

    in
      tarball //
        { meta = {
            description = "NixOS system tarball for ${system} - ${stdenv.hostPlatform.linux-kernel.name}";
            maintainers = map (x: lib.maintainers.${x}) maintainers;
          };
          inherit config;
        };


  makeClosure = module: buildFromConfig module (config: config.system.build.toplevel);


  buildFromConfig = module: sel: forAllSystems (system: hydraJob (sel (import ./lib/eval-config.nix {
    inherit system;
    modules = makeModules module
      ({ ... }:
      { fileSystems."/".device  = mkDefault "/dev/sda1";
        boot.loader.grub.device = mkDefault "/dev/sda";
      });
  }).config));

  makeNetboot = { module, system, ... }:
    let
      configEvaled = import lib/eval-config.nix {
        inherit system;
        modules = makeModules module {};
      };
      build = configEvaled.config.system.build;
      kernelTarget = configEvaled.pkgs.stdenv.hostPlatform.linux-kernel.target;
    in
      pkgs.symlinkJoin {
        name = "netboot";
        paths = [
          build.netbootRamdisk
          build.kernel
          build.netbootIpxeScript
        ];
        postBuild = ''
          mkdir -p $out/nix-support
          echo "file ${kernelTarget} ${build.kernel}/${kernelTarget}" >> $out/nix-support/hydra-build-products
          echo "file initrd ${build.netbootRamdisk}/initrd" >> $out/nix-support/hydra-build-products
          echo "file ipxe ${build.netbootIpxeScript}/netboot.ipxe" >> $out/nix-support/hydra-build-products
        '';
        preferLocalBuild = true;
      };

in rec {

  channel = import lib/make-channel.nix { inherit pkgs nixpkgs version versionSuffix; };

  manualHTML = buildFromConfig ({ ... }: { }) (config: config.system.build.manual.manualHTML);
  manual = manualHTML; # TODO(@oxij): remove eventually
  manualEpub = (buildFromConfig ({ ... }: { }) (config: config.system.build.manual.manualEpub));
  manpages = buildFromConfig ({ ... }: { }) (config: config.system.build.manual.manpages);
  manualGeneratedSources = buildFromConfig ({ ... }: { }) (config: config.system.build.manual.generatedSources);
  options = (buildFromConfig ({ ... }: { }) (config: config.system.build.manual.optionsJSON)).x86_64-linux;


  # Build the initial ramdisk so Hydra can keep track of its size over time.
  initialRamdisk = buildFromConfig ({ ... }: { }) (config: config.system.build.initialRamdisk);

  kexec = forMatchingSystems supportedSystems (system: (import lib/eval-config.nix {
    inherit system;
    modules = [
      ./modules/installer/netboot/netboot-minimal.nix
    ];
  }).config.system.build.kexecTree);

  netboot = forMatchingSystems supportedSystems (system: makeNetboot {
    module = ./modules/installer/netboot/netboot-minimal.nix;
    inherit system;
  });

  iso_minimal = forAllSystems (system: makeIso {
    module = ./modules/installer/cd-dvd/installation-cd-minimal.nix;
    type = "minimal";
    inherit system;
  });

  iso_plasma5 = forMatchingSystems [ "x86_64-linux" ] (system: makeIso {
    module = ./modules/installer/cd-dvd/installation-cd-graphical-calamares-plasma5.nix;
    type = "plasma5";
    inherit system;
  });

  iso_gnome = forMatchingSystems [ "x86_64-linux" ] (system: makeIso {
    module = ./modules/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix;
    type = "gnome";
    inherit system;
  });

  # A variant with a more recent (but possibly less stable) kernel
  # that might support more hardware.
  iso_minimal_new_kernel = forMatchingSystems [ "x86_64-linux" "aarch64-linux" ] (system: makeIso {
    module = ./modules/installer/cd-dvd/installation-cd-minimal-new-kernel.nix;
    type = "minimal-new-kernel";
    inherit system;
  });

  sd_image = forMatchingSystems [ "armv6l-linux" "armv7l-linux" "aarch64-linux" ] (system: makeSdImage {
    module = {
        armv6l-linux = ./modules/installer/sd-card/sd-image-raspberrypi-installer.nix;
        armv7l-linux = ./modules/installer/sd-card/sd-image-armv7l-multiplatform-installer.nix;
        aarch64-linux = ./modules/installer/sd-card/sd-image-aarch64-installer.nix;
      }.${system};
    inherit system;
  });

  sd_image_new_kernel = forMatchingSystems [ "aarch64-linux" ] (system: makeSdImage {
    module = {
        aarch64-linux = ./modules/installer/sd-card/sd-image-aarch64-new-kernel-installer.nix;
      }.${system};
    type = "minimal-new-kernel";
    inherit system;
  });

  # A bootable VirtualBox virtual appliance as an OVA file (i.e. packaged OVF).
  ova = forMatchingSystems [ "x86_64-linux" ] (system:

    with import ./.. { inherit system; };

    hydraJob ((import lib/eval-config.nix {
      inherit system;
      modules =
        [ versionModule
          ./modules/installer/virtualbox-demo.nix
        ];
    }).config.system.build.virtualBoxOVA)

  );

  # KVM image for proxmox in VMA format
  proxmoxImage = forMatchingSystems [ "x86_64-linux" ] (system:
    with import ./.. { inherit system; };

    hydraJob ((import lib/eval-config.nix {
      inherit system;
      modules = [
        ./modules/virtualisation/proxmox-image.nix
      ];
    }).config.system.build.VMA)
  );

  # LXC tarball for proxmox
  proxmoxLXC = forMatchingSystems [ "x86_64-linux" ] (system:
    with import ./.. { inherit system; };

    hydraJob ((import lib/eval-config.nix {
      inherit system;
      modules = [
        ./modules/virtualisation/proxmox-lxc.nix
      ];
    }).config.system.build.tarball)
  );

  # A disk image that can be imported to Amazon EC2 and registered as an AMI
  amazonImage = forMatchingSystems [ "x86_64-linux" "aarch64-linux" ] (system:

    with import ./.. { inherit system; };

    hydraJob ((import lib/eval-config.nix {
      inherit system;
      modules =
        [ configuration
          versionModule
          ./maintainers/scripts/ec2/amazon-image.nix
        ];
    }).config.system.build.amazonImage)

  );
  amazonImageZfs = forMatchingSystems [ "x86_64-linux" "aarch64-linux" ] (system:

    with import ./.. { inherit system; };

    hydraJob ((import lib/eval-config.nix {
      inherit system;
      modules =
        [ configuration
          versionModule
          ./maintainers/scripts/ec2/amazon-image-zfs.nix
        ];
    }).config.system.build.amazonImage)

  );


  # Test job for https://github.com/NixOS/nixpkgs/issues/121354 to test
  # automatic sizing without blocking the channel.
  amazonImageAutomaticSize = forMatchingSystems [ "x86_64-linux" "aarch64-linux" ] (system:

    with import ./.. { inherit system; };

    hydraJob ((import lib/eval-config.nix {
      inherit system;
      modules =
        [ configuration
          versionModule
          ./maintainers/scripts/ec2/amazon-image.nix
          ({ ... }: { amazonImage.sizeMB = "auto"; })
        ];
    }).config.system.build.amazonImage)

  );

  # An image that can be imported into lxd and used for container creation
  lxdImage = forMatchingSystems [ "x86_64-linux" "aarch64-linux" ] (system:

    with import ./.. { inherit system; };

    hydraJob ((import lib/eval-config.nix {
      inherit system;
      modules =
        [ configuration
          versionModule
          ./maintainers/scripts/lxd/lxd-image.nix
        ];
    }).config.system.build.tarball)

  );

  # Metadata for the lxd image
  lxdMeta = forMatchingSystems [ "x86_64-linux" "aarch64-linux" ] (system:

    with import ./.. { inherit system; };

    hydraJob ((import lib/eval-config.nix {
      inherit system;
      modules =
        [ configuration
          versionModule
          ./maintainers/scripts/lxd/lxd-image.nix
        ];
    }).config.system.build.metadata)

  );

  # Ensure that all packages used by the minimal NixOS config end up in the channel.
  dummy = forAllSystems (system: pkgs.runCommand "dummy"
    { toplevel = (import lib/eval-config.nix {
        inherit system;
        modules = singleton ({ ... }:
          { fileSystems."/".device  = mkDefault "/dev/sda1";
            boot.loader.grub.device = mkDefault "/dev/sda";
            system.stateVersion = mkDefault "18.03";
          });
      }).config.system.build.toplevel;
      preferLocalBuild = true;
    }
    "mkdir $out; ln -s $toplevel $out/dummy");


  # Provide container tarball for lxc, libvirt-lxc, docker-lxc, ...
  containerTarball = forAllSystems (system: makeSystemTarball {
    module = ./modules/virtualisation/lxc-container.nix;
    inherit system;
  });

  tests = allTests;

  /* Build a bunch of typical closures so that Hydra can keep track of
     the evolution of closure sizes. */

  closures = {

    smallContainer = makeClosure ({ ... }:
      { boot.isContainer = true;
        services.openssh.enable = true;
      });

    tinyContainer = makeClosure ({ ... }:
      { boot.isContainer = true;
        imports = [ modules/profiles/minimal.nix ];
      });

    ec2 = makeClosure ({ ... }:
      { imports = [ modules/virtualisation/amazon-image.nix ];
      });

    kde = makeClosure ({ ... }:
      { services.xserver.enable = true;
        services.xserver.displayManager.sddm.enable = true;
        services.xserver.desktopManager.plasma5.enable = true;
      });

    xfce = makeClosure ({ ... }:
      { services.xserver.enable = true;
        services.xserver.desktopManager.xfce.enable = true;
      });

    gnome = makeClosure ({ ... }:
      { services.xserver.enable = true;
        services.xserver.displayManager.gdm.enable = true;
        services.xserver.desktopManager.gnome.enable = true;
      });

    pantheon = makeClosure ({ ... }:
      { services.xserver.enable = true;
        services.xserver.desktopManager.pantheon.enable = true;
      });

    # Linux/Apache/PostgreSQL/PHP stack.
    lapp = makeClosure ({ pkgs, ... }:
      { services.httpd.enable = true;
        services.httpd.adminAddr = "foo@example.org";
        services.httpd.enablePHP = true;
        services.postgresql.enable = true;
        services.postgresql.package = pkgs.postgresql;
      });
  };
}
