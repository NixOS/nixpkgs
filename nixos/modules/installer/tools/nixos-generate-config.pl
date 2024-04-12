#! @perl@

use strict;
use Cwd 'abs_path';
use File::Spec;
use File::Path;
use File::Basename;
use File::Slurp;
use File::stat;

umask(0022);

sub uniq {
    my %seen;
    my @res = ();
    foreach my $s (@_) {
        if (!defined $seen{$s}) {
            $seen{$s} = 1;
            push @res, $s;
        }
    }
    return @res;
}

sub runCommand {
    my ($cmd) = @_;
    open FILE, "$cmd 2>&1 |" or die "Failed to execute: $cmd\n";
    my @ret = <FILE>;
    close FILE;
    return ($?, @ret);
}

# Process the command line.
my $outDir = "/etc/nixos";
my $rootDir = ""; # = /
my $force = 0;
my $noFilesystems = 0;
my $showHardwareConfig = 0;

for (my $n = 0; $n < scalar @ARGV; $n++) {
    my $arg = $ARGV[$n];
    if ($arg eq "--help") {
        exec "man nixos-generate-config" or die;
    }
    elsif ($arg eq "--dir") {
        $n++;
        $outDir = $ARGV[$n];
        die "$0: ‘--dir’ requires an argument\n" unless defined $outDir;
    }
    elsif ($arg eq "--root") {
        $n++;
        $rootDir = $ARGV[$n];
        die "$0: ‘--root’ requires an argument\n" unless defined $rootDir;
        die "$0: no need to specify `/` with `--root`, it is the default\n" if $rootDir eq "/";
        $rootDir =~ s/\/*$//; # remove trailing slashes
        $rootDir = File::Spec->rel2abs($rootDir); # resolve absolute path
    }
    elsif ($arg eq "--force") {
        $force = 1;
    }
    elsif ($arg eq "--no-filesystems") {
        $noFilesystems = 1;
    }
    elsif ($arg eq "--show-hardware-config") {
        $showHardwareConfig = 1;
    }
    else {
        die "$0: unrecognized argument ‘$arg’\n";
    }
}


my @attrs = ();
my @kernelModules = ();
my @initrdKernelModules = ();
my @initrdAvailableKernelModules = ();
my @modulePackages = ();
my @imports;


sub debug {
    return unless defined $ENV{"DEBUG"};
    print STDERR @_;
}


# nixpkgs.system
push @attrs, "nixpkgs.hostPlatform = lib.mkDefault \"@hostPlatformSystem@\";";


my $cpuinfo = read_file "/proc/cpuinfo";


sub hasCPUFeature {
    my $feature = shift;
    return $cpuinfo =~ /^flags\s*:.* $feature( |$)/m;
}


sub cpuManufacturer {
    my $id = shift;
    return $cpuinfo =~ /^vendor_id\s*:.* $id$/m;
}

# Virtualization support?
push @kernelModules, "kvm-intel" if hasCPUFeature "vmx";
push @kernelModules, "kvm-amd" if hasCPUFeature "svm";


# Look at the PCI devices and add necessary modules.  Note that most
# modules are auto-detected so we don't need to list them here.
# However, some are needed in the initrd to boot the system.

my $videoDriver;

sub pciCheck {
    my $path = shift;
    my $vendor = read_file "$path/vendor"; chomp $vendor;
    my $device = read_file "$path/device"; chomp $device;
    my $class = read_file "$path/class"; chomp $class;

    my $module;
    if (-e "$path/driver/module") {
        $module = basename `readlink -f $path/driver/module`;
        chomp $module;
    }

    debug "$path: $vendor $device $class";
    debug " $module" if defined $module;
    debug "\n";

    if (defined $module) {
        # See the bottom of https://pciids.sourceforge.net/pci.ids for
        # device classes.
        if (# Mass-storage controller.  Definitely important.
            $class =~ /^0x01/ ||

            # Firewire controller.  A disk might be attached.
            $class =~ /^0x0c00/ ||

            # USB controller.  Needed if we want to use the
            # keyboard when things go wrong in the initrd.
            $class =~ /^0x0c03/
            )
        {
            push @initrdAvailableKernelModules, $module;
        }
    }

    # broadcom STA driver (wl.ko)
    # list taken from http://www.broadcom.com/docs/linux_sta/README.txt
    if ($vendor eq "0x14e4" &&
        ($device eq "0x4311" || $device eq "0x4312" || $device eq "0x4313" ||
         $device eq "0x4315" || $device eq "0x4327" || $device eq "0x4328" ||
         $device eq "0x4329" || $device eq "0x432a" || $device eq "0x432b" ||
         $device eq "0x432c" || $device eq "0x432d" || $device eq "0x4353" ||
         $device eq "0x4357" || $device eq "0x4358" || $device eq "0x4359" ||
         $device eq "0x4331" || $device eq "0x43a0" || $device eq "0x43b1"
        ) )
     {
        push @modulePackages, "config.boot.kernelPackages.broadcom_sta";
        push @kernelModules, "wl";
     }

    # broadcom FullMac driver
    # list taken from
    # https://wireless.wiki.kernel.org/en/users/Drivers/brcm80211#brcmfmac
    if ($vendor eq "0x14e4" &&
        ($device eq "0x43a3" || $device eq "0x43df" || $device eq "0x43ec" ||
         $device eq "0x43d3" || $device eq "0x43d9" || $device eq "0x43e9" ||
         $device eq "0x43ba" || $device eq "0x43bb" || $device eq "0x43bc" ||
         $device eq "0xaa52" || $device eq "0x43ca" || $device eq "0x43cb" ||
         $device eq "0x43cc" || $device eq "0x43c3" || $device eq "0x43c4" ||
         $device eq "0x43c5"
        ) )
    {
        # we need e.g. brcmfmac43602-pcie.bin
        push @imports, "(modulesPath + \"/hardware/network/broadcom-43xx.nix\")";
    }

    # In case this is a virtio scsi device, we need to explicitly make this available.
    if ($vendor eq "0x1af4" && ($device eq "0x1004" || $device eq "0x1048") ) {
        push @initrdAvailableKernelModules, "virtio_scsi";
    }

    # Can't rely on $module here, since the module may not be loaded
    # due to missing firmware.  Ideally we would check modules.pcimap
    # here.
    push @attrs, "networking.enableIntel2200BGFirmware = true;" if
        $vendor eq "0x8086" &&
        ($device eq "0x1043" || $device eq "0x104f" || $device eq "0x4220" ||
         $device eq "0x4221" || $device eq "0x4223" || $device eq "0x4224");

    push @attrs, "networking.enableIntel3945ABGFirmware = true;" if
        $vendor eq "0x8086" &&
        ($device eq "0x4229" || $device eq "0x4230" ||
         $device eq "0x4222" || $device eq "0x4227");

    # Assume that all NVIDIA cards are supported by the NVIDIA driver.
    # There may be exceptions (e.g. old cards).
    # FIXME: do we want to enable an unfree driver here?
    #$videoDriver = "nvidia" if $vendor eq "0x10de" && $class =~ /^0x03/;
}

foreach my $path (glob "/sys/bus/pci/devices/*") {
    pciCheck $path;
}

# Idem for USB devices.

sub usbCheck {
    my $path = shift;
    my $class = read_file "$path/bInterfaceClass"; chomp $class;
    my $subclass = read_file "$path/bInterfaceSubClass"; chomp $subclass;
    my $protocol = read_file "$path/bInterfaceProtocol"; chomp $protocol;

    my $module;
    if (-e "$path/driver/module") {
        $module = basename `readlink -f $path/driver/module`;
        chomp $module;
    }

    debug "$path: $class $subclass $protocol";
    debug " $module" if defined $module;
    debug "\n";

    if (defined $module) {
        if (# Mass-storage controller.  Definitely important.
            $class eq "08" ||

            # Keyboard.  Needed if we want to use the
            # keyboard when things go wrong in the initrd.
            ($class eq "03" && $protocol eq "01")
            )
        {
            push @initrdAvailableKernelModules, $module;
        }
    }
}

foreach my $path (glob "/sys/bus/usb/devices/*") {
    if (-e "$path/bInterfaceClass") {
        usbCheck $path;
    }
}


# Add the modules for all block and MMC devices.
foreach my $path (glob "/sys/class/{block,mmc_host}/*") {
    my $module;
    if (-e "$path/device/driver/module") {
        $module = basename `readlink -f $path/device/driver/module`;
        chomp $module;
        push @initrdAvailableKernelModules, $module;
    }
}

# Add bcache module, if needed.
my @bcacheDevices = glob("/dev/bcache*");
@bcacheDevices = grep(!qr#dev/bcachefs.*#, @bcacheDevices);
if (scalar @bcacheDevices > 0) {
    push @initrdAvailableKernelModules, "bcache";
}

# Prevent unbootable systems if LVM snapshots are present at boot time.
if (`lsblk -o TYPE` =~ "lvm") {
    push @initrdKernelModules, "dm-snapshot";
}

my $virt = `@detectvirt@`;
chomp $virt;


# Check if we're a VirtualBox guest.  If so, enable the guest
# additions.
if ($virt eq "oracle") {
    push @attrs, "virtualisation.virtualbox.guest.enable = true;"
}

# Check if we're a Parallels guest. If so, enable the guest additions.
# It is blocked by https://github.com/systemd/systemd/pull/23859
if ($virt eq "parallels") {
    push @attrs, "hardware.parallels.enable = true;";
    push @attrs, "nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ \"prl-tools\" ];";
}

# Likewise for QEMU.
if ($virt eq "qemu" || $virt eq "kvm" || $virt eq "bochs") {
    push @imports, "(modulesPath + \"/profiles/qemu-guest.nix\")";
}

# Also for Hyper-V.
if ($virt eq "microsoft") {
    push @attrs, "virtualisation.hypervGuest.enable = true;"
}


# Pull in NixOS configuration for containers.
if ($virt eq "systemd-nspawn") {
    push @attrs, "boot.isContainer = true;";
}


# Check if we're on bare metal, not in a VM/container.
if ($virt eq "none") {
    # Provide firmware for devices that are not detected by this script.
    push @imports, "(modulesPath + \"/installer/scan/not-detected.nix\")";

    # Update the microcode.
    push @attrs, "hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;" if cpuManufacturer "AuthenticAMD";
    push @attrs, "hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;" if cpuManufacturer "GenuineIntel";
}

# For a device name like /dev/sda1, find a more stable path like
# /dev/disk/by-uuid/X or /dev/disk/by-label/Y.
sub findStableDevPath {
    my ($dev) = @_;
    return $dev if substr($dev, 0, 1) ne "/";
    return $dev unless -e $dev;

    my $st = stat($dev) or return $dev;

    foreach my $dev2 (glob("/dev/stratis/*/*"), glob("/dev/disk/by-uuid/*"), glob("/dev/mapper/*"), glob("/dev/disk/by-label/*")) {
        my $st2 = stat($dev2) or next;
        return $dev2 if $st->rdev == $st2->rdev;
    }

    return $dev;
}

push @attrs, "services.xserver.videoDrivers = [ \"$videoDriver\" ];" if $videoDriver;

# Generate the swapDevices option from the currently activated swap
# devices.
my @swaps = read_file("/proc/swaps", err_mode => 'carp');
my @swapDevices;
if (@swaps) {
    shift @swaps;
    foreach my $swap (@swaps) {
        my @fields = split ' ', $swap;
        my $swapFilename = $fields[0];
        my $swapType = $fields[1];
        next unless -e $swapFilename;
        my $dev = findStableDevPath $swapFilename;
        if ($swapType =~ "partition") {
            # zram devices are more likely created by configuration.nix, so
            # ignore them here
            next if ($swapFilename =~ /^\/dev\/zram/);
            push @swapDevices, "{ device = \"$dev\"; }";
        } elsif ($swapType =~ "file") {
            # swap *files* are more likely specified in configuration.nix, so
            # ignore them here.
        } else {
            die "Unsupported swap type: $swapType\n";
        }
    }
}


# Generate the fileSystems option from the currently mounted
# filesystems.
sub in {
    my ($d1, $d2) = @_;
    return $d1 eq $d2 || substr($d1, 0, length($d2) + 1) eq "$d2/";
}

my $fileSystems;
my %fsByDev;
my $useSwraid = 0;
foreach my $fs (read_file("/proc/self/mountinfo")) {
    chomp $fs;
    my @fields = split / /, $fs;
    my $mountPoint = $fields[4];
    $mountPoint =~ s/\\040/ /g; # account for mount points with spaces in the name (\040 is the escape character)
    $mountPoint =~ s/\\011/\t/g; # account for mount points with tabs in the name (\011 is the escape character)
    next unless -d $mountPoint;
    my @mountOptions = split /,/, $fields[5];

    next if !in($mountPoint, $rootDir);
    $mountPoint = substr($mountPoint, length($rootDir)); # strip the root directory (e.g. /mnt)
    $mountPoint = "/" if $mountPoint eq "";

    # Skip special filesystems.
    next if in($mountPoint, "/proc") || in($mountPoint, "/dev") || in($mountPoint, "/sys") || in($mountPoint, "/run") || $mountPoint eq "/var/lib/nfs/rpc_pipefs";

    # Skip the optional fields.
    my $n = 6; $n++ while $fields[$n] ne "-"; $n++;
    my $fsType = $fields[$n];
    my $device = $fields[$n + 1];
    my @superOptions = split /,/, $fields[$n + 2];
    $device =~ s/\\040/ /g; # account for devices with spaces in the name (\040 is the escape character)
    $device =~ s/\\011/\t/g; # account for mount points with tabs in the name (\011 is the escape character)

    # Skip the read-only bind-mount on /nix/store.
    next if $mountPoint eq "/nix/store" && (grep { $_ eq "rw" } @superOptions) && (grep { $_ eq "ro" } @mountOptions);

    # Maybe this is a bind-mount of a filesystem we saw earlier?
    if (defined $fsByDev{$fields[2]}) {
        # Make sure this isn't a btrfs subvolume.
        my $msg = `@btrfs@ subvol show $rootDir$mountPoint`;
        if ($? != 0 || $msg =~ /ERROR:/s) {
            my $path = $fields[3]; $path = "" if $path eq "/";
            my $base = $fsByDev{$fields[2]};
            $base = "" if $base eq "/";
            $fileSystems .= <<EOF;
  fileSystems.\"$mountPoint\" =
    { device = \"$base$path\";
      fsType = \"none\";
      options = \[ \"bind\" \];
    };

EOF
            next;
        }
    }
    $fsByDev{$fields[2]} = $mountPoint;

    # We don't know how to handle FUSE filesystems.
    if ($fsType eq "fuseblk" || $fsType eq "fuse") {
        print STDERR "warning: don't know how to emit ‘fileSystem’ option for FUSE filesystem ‘$mountPoint’\n";
        next;
    }

    # Is this a mount of a loopback device?
    my @extraOptions;
    if ($device =~ /\/dev\/loop(\d+)/) {
        my $loopnr = $1;
        my $backer = read_file "/sys/block/loop$loopnr/loop/backing_file";
        if (defined $backer) {
            chomp $backer;
            $device = $backer;
            push @extraOptions, "loop";
        }
    }

    # Is this a btrfs filesystem?
    if ($fsType eq "btrfs") {
        my ($status, @info) = runCommand("@btrfs@ subvol show $rootDir$mountPoint");
        if ($status != 0 || join("", @info) =~ /ERROR:/) {
            die "Failed to retrieve subvolume info for $mountPoint\n";
        }
        my @ids = join("\n", @info) =~ m/^(?!\/\n).*Subvolume ID:[ \t\n]*([0-9]+)/s;
        if ($#ids > 0) {
            die "Btrfs subvol name for $mountPoint listed multiple times in mount\n"
        } elsif ($#ids == 0) {
            my @paths = join("", @info) =~ m/^([^\n]*)/;
            if ($#paths > 0) {
                die "Btrfs returned multiple paths for a single subvolume id, mountpoint $mountPoint\n";
            } elsif ($#paths != 0) {
                die "Btrfs did not return a path for the subvolume at $mountPoint\n";
            }
            push @extraOptions, "subvol=$paths[0]";
        }
    }

    # Preserve umask (fmask, dmask) settings for vfat filesystems.
    # (The default is to mount these world-readable, but that's a security risk
    # for the EFI System Partition.)
    if ($fsType eq "vfat") {
        for (@superOptions) {
            if ($_ =~ /fmask|dmask/) {
                push @extraOptions, $_;
            }
        }
    }

    # is this a stratis fs?
    my $stableDevPath = findStableDevPath $device;
    my $stratisPool;
    if ($stableDevPath =~ qr#/dev/stratis/(.*)/.*#) {
        my $poolName = $1;
        my ($header, @lines) = split "\n", qx/stratis pool list/;
        my $uuidIndex = index $header, 'UUID';
        my ($line) = grep /^$poolName /, @lines;
        $stratisPool = substr $line, $uuidIndex - 32, 36;
    }

    # Don't emit tmpfs entry for /tmp, because it most likely comes from the
    # boot.tmp.useTmpfs option in configuration.nix (managed declaratively).
    next if ($mountPoint eq "/tmp" && $fsType eq "tmpfs");

    # This should work for single and multi-device systems.
    # still needs subvolume support
    if ($fsType eq "bcachefs") {
        my ($status, @info) = runCommand("bcachefs fs usage $rootDir$mountPoint");
        my $UUID = $info[0];

        if ($status == 0 && $UUID =~ /^Filesystem:[ \t\n]*([0-9a-z-]+)/) {
            $stableDevPath = "UUID=$1";
        } else {
            print STDERR "warning: can't find bcachefs mount UUID falling back to device-path";
        }
    }

    # Emit the filesystem.
    $fileSystems .= <<EOF;
  fileSystems.\"$mountPoint\" =
    { device = \"$stableDevPath\";
      fsType = \"$fsType\";
EOF

    if (scalar @extraOptions > 0) {
        $fileSystems .= <<EOF;
      options = \[ ${\join " ", map { "\"" . $_ . "\"" } uniq(@extraOptions)} \];
EOF
    }

    if ($stratisPool) {
        $fileSystems .= <<EOF;
      stratis.poolUuid = "$stratisPool";
EOF
    }

    $fileSystems .= <<EOF;
    };

EOF

    # If this filesystem is on a LUKS device, then add a
    # boot.initrd.luks.devices entry.
    if (-e $device) {
        my $deviceName = basename(abs_path($device));
        my $dmUuid = read_file("/sys/class/block/$deviceName/dm/uuid",  err_mode => 'quiet');
        if ($dmUuid =~ /^CRYPT-LUKS/)
        {
            my @slaves = glob("/sys/class/block/$deviceName/slaves/*");
            if (scalar @slaves == 1) {
                my $slave = "/dev/" . basename($slaves[0]);
                if (-e $slave) {
                    my $dmName = read_file("/sys/class/block/$deviceName/dm/name");
                    chomp $dmName;
                    # Ensure to add an entry only once
                    my $luksDevice = "  boot.initrd.luks.devices.\"$dmName\".device";
                    if ($fileSystems !~ /^\Q$luksDevice\E/m) {
                        $fileSystems .= "$luksDevice = \"${\(findStableDevPath $slave)}\";\n\n";
                    }
                }
            }
        }
        if (-e "/sys/class/block/$deviceName/md/uuid") {
            $useSwraid = 1;
        }
    }
}
if ($useSwraid) {
    push @attrs, "boot.swraid.enable = true;\n\n";
}


# Generate the hardware configuration file.

sub toNixStringList {
    my $res = "";
    foreach my $s (@_) {
        $res .= " \"$s\"";
    }
    return $res;
}
sub toNixList {
    my $res = "";
    foreach my $s (@_) {
        $res .= " $s";
    }
    return $res;
}

sub multiLineList {
    my $indent = shift;
    return " [ ]" if !@_;
    my $res = "\n${indent}[ ";
    my $first = 1;
    foreach my $s (@_) {
        $res .= "$indent  " if !$first;
        $first = 0;
        $res .= "$s\n";
    }
    $res .= "$indent]";
    return $res;
}

my $initrdAvailableKernelModules = toNixStringList(uniq @initrdAvailableKernelModules);
my $initrdKernelModules = toNixStringList(uniq @initrdKernelModules);
my $kernelModules = toNixStringList(uniq @kernelModules);
my $modulePackages = toNixList(uniq @modulePackages);

my $fsAndSwap = "";
if (!$noFilesystems) {
    $fsAndSwap = "\n$fileSystems  ";
    $fsAndSwap .= "swapDevices =" . multiLineList("    ", @swapDevices) . ";\n";
}

my $networkingDhcpConfig = generateNetworkingDhcpConfig();

my $hwConfig = <<EOF;
# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =${\multiLineList("    ", @imports)};

  boot.initrd.availableKernelModules = [$initrdAvailableKernelModules ];
  boot.initrd.kernelModules = [$initrdKernelModules ];
  boot.kernelModules = [$kernelModules ];
  boot.extraModulePackages = [$modulePackages ];
$fsAndSwap
$networkingDhcpConfig
${\join "", (map { "  $_\n" } (uniq @attrs))}}
EOF

sub generateNetworkingDhcpConfig {
    # FIXME disable networking.useDHCP by default when switching to networkd.
    my $config = <<EOF;
  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
EOF

    foreach my $path (glob "/sys/class/net/*") {
        my $dev = basename($path);
        if ($dev ne "lo") {
            $config .= "  # networking.interfaces.$dev.useDHCP = lib.mkDefault true;\n";
        }
    }

    return $config;
}

sub generateXserverConfig {
    my $xserverEnabled = "@xserverEnabled@";

    my $config = "";
    if ($xserverEnabled eq "1") {
        $config = <<EOF;
  # Enable the X11 windowing system.
  services.xserver.enable = true;
EOF
    } else {
        $config = <<EOF;
  # Enable the X11 windowing system.
  # services.xserver.enable = true;
EOF
    }
}

if ($showHardwareConfig) {
    print STDOUT $hwConfig;
} else {
    if ($outDir eq "/etc/nixos") {
        $outDir = "$rootDir$outDir";
    } else {
        $outDir = File::Spec->rel2abs($outDir);
        $outDir =~ s/\/*$//; # remove trailing slashes
    }

    my $fn = "$outDir/hardware-configuration.nix";
    print STDERR "writing $fn...\n";
    mkpath($outDir, 0, 0755);
    write_file($fn, $hwConfig);

    # Generate a basic configuration.nix, unless one already exists.
    $fn = "$outDir/configuration.nix";
    if ($force || ! -e $fn) {
        print STDERR "writing $fn...\n";

        my $bootLoaderConfig = "";
        if (-e "/sys/firmware/efi/efivars") {
            $bootLoaderConfig = <<EOF;
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
EOF
        } elsif (-e "/boot/extlinux") {
            $bootLoaderConfig = <<EOF;
  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;
EOF
        } elsif ($virt ne "systemd-nspawn") {
            $bootLoaderConfig = <<EOF;
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
EOF
        }

        my $networkingDhcpConfig = generateNetworkingDhcpConfig();

        my $xserverConfig = generateXserverConfig();

        (my $desktopConfiguration = <<EOF)=~s/^/  /gm;
@desktopConfiguration@
EOF

        write_file($fn, <<EOF);
@configuration@
EOF
        print STDERR "For more hardware-specific settings, see https://github.com/NixOS/nixos-hardware.\n"
    } else {
        print STDERR "warning: not overwriting existing $fn\n";
    }
}

# workaround for a bug in substituteAll
