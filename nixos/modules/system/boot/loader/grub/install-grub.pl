use strict;
use warnings;
use Class::Struct;
use XML::LibXML;
use File::Basename;
use File::Path;
use File::stat;
use File::Copy;
use File::Slurp;
use POSIX;
use Cwd;

my $defaultConfig = $ARGV[1] or die;

my $dom = XML::LibXML->load_xml(location => $ARGV[0]);

sub get { my ($name) = @_; return $dom->findvalue("/expr/attrs/attr[\@name = '$name']/*/\@value"); }

sub readFile {
    my ($fn) = @_; local $/ = undef;
    open FILE, "<$fn" or return undef; my $s = <FILE>; close FILE;
    local $/ = "\n"; chomp $s; return $s;
}

sub writeFile {
    my ($fn, $s) = @_;
    open FILE, ">$fn" or die "cannot create $fn: $!\n";
    print FILE $s or die;
    close FILE or die;
}

sub runCommand {
    my ($cmd) = @_;
    open FILE, "$cmd 2>/dev/null |" or die "Failed to execute: $cmd\n";
    my @ret = <FILE>;
    close FILE;
    return ($?, @ret);
}

my $grub = get("grub");
my $grubVersion = int(get("version"));
my $extraConfig = get("extraConfig");
my $extraPrepareConfig = get("extraPrepareConfig");
my $extraPerEntryConfig = get("extraPerEntryConfig");
my $extraEntries = get("extraEntries");
my $extraEntriesBeforeNixOS = get("extraEntriesBeforeNixOS") eq "true";
my $splashImage = get("splashImage");
my $configurationLimit = int(get("configurationLimit"));
my $copyKernels = get("copyKernels") eq "true";
my $timeout = int(get("timeout"));
my $defaultEntry = int(get("default"));
my $fsIdentifier = get("fsIdentifier");
$ENV{'PATH'} = get("path");

die "unsupported GRUB version\n" if $grubVersion != 1 && $grubVersion != 2;

print STDERR "updating GRUB $grubVersion menu...\n";

mkpath("/boot/grub", 0, 0700);

# Discover whether /boot is on the same filesystem as / and
# /nix/store.  If not, then all kernels and initrds must be copied to
# /boot.
if (stat("/boot")->dev != stat("/nix/store")->dev) {
    $copyKernels = 1;
}

# Discover information about the location of /boot
struct(Fs => {
    device => '$',
    type => '$',
    mount => '$',
});
sub PathInMount {
    my ($path, $mount) = @_;
    my @splitMount = split /\//, $mount;
    my @splitPath = split /\//, $path;
    if ($#splitPath < $#splitMount) {
        return 0;
    }
    for (my $i = 0; $i <= $#splitMount; $i++) {
        if ($splitMount[$i] ne $splitPath[$i]) {
            return 0;
        }
    }
    return 1;
}
sub GetFs {
    my ($dir) = @_;
    my $bestFs = Fs->new(device => "", type => "", mount => "");
    foreach my $fs (read_file("/proc/self/mountinfo")) {
        chomp $fs;
        my @fields = split / /, $fs;
        my $mountPoint = $fields[4];
        next unless -d $mountPoint;
        my @mountOptions = split /,/, $fields[5];

        # Skip the optional fields.
        my $n = 6; $n++ while $fields[$n] ne "-"; $n++;
        my $fsType = $fields[$n];
        my $device = $fields[$n + 1];
        my @superOptions = split /,/, $fields[$n + 2];

        # Skip the read-only bind-mount on /nix/store.
        next if $mountPoint eq "/nix/store" && (grep { $_ eq "rw" } @superOptions) && (grep { $_ eq "ro" } @mountOptions);

        # Ensure this matches the intended directory
        next unless PathInMount($dir, $mountPoint);

        # Is it better than our current match?
        if (length($mountPoint) > length($bestFs->mount)) {
            $bestFs = Fs->new(device => $device, type => $fsType, mount => $mountPoint);
        }
    }
    return $bestFs;
}
struct (Grub => {
    path => '$',
    search => '$',
});
my $driveid = 1;
sub GrubFs {
    my ($dir) = @_;
    my $fs = GetFs($dir);
    my $path = "/" . substr($dir, length($fs->mount));
    my $search = "";

    if ($grubVersion > 1) {
        # ZFS is completely separate logic as zpools are always identified by a label
        # or custom UUID
        if ($fs->type eq 'zfs') {
            my $sid = index($fs->device, '/');

            if ($sid < 0) {
                $search = '--label ' . $fs->device;
                $path = '/@' . $path;
            } else {
                $search = '--label ' . substr($fs->device, 0, $sid);
                $path = '/' . substr($fs->device, $sid) . '/@' . $path;
            }
        } else {
            my %types = ('uuid' => '--fs-uuid', 'label' => '--label');

            if ($fsIdentifier eq 'provided') {
                # If the provided dev is identifying the partition using a label or uuid,
                # we should get the label / uuid and do a proper search
                my @matches = $fs->device =~ m/\/dev\/disk\/by-(label|uuid)\/(.*)/;
                if ($#matches > 1) {
                    die "Too many matched devices"
                } elsif ($#matches == 1) {
                    $search = "$types{$matches[0]} $matches[1]"
                }
            } else {
                # Determine the identifying type
                $search = $types{$fsIdentifier} . ' ';

                # Based on the type pull in the identifier from the system
                my ($status, @devInfo) = runCommand("blkid -o export @{[$fs->device]}");
                if ($status != 0) {
                    die "Failed to get blkid info for @{[$fs->mount]} on @{[$fs->device]}";
                }
                my @matches = join("", @devInfo) =~ m/@{[uc $fsIdentifier]}=([^\n]*)/;
                if ($#matches != 0) {
                    die "Couldn't find a $types{$fsIdentifier} for @{[$fs->device]}\n"
                }
                $search .= $matches[0];
            }

            # BTRFS is a special case in that we need to fix the referrenced path based on subvolumes
            if ($fs->type eq 'btrfs') {
                my ($status, @id_info) = runCommand("btrfs subvol show @{[$fs->mount]}");
                if ($status != 0) {
                    die "Failed to retrieve subvolume info for @{[$fs->mount]}\n";
                }
                my @ids = join("", @id_info) =~ m/Object ID:[ \t\n]*([^ \t\n]*)/;
                if ($#ids > 0) {
                    die "Btrfs subvol name for @{[$fs->device]} listed multiple times in mount\n"
                } elsif ($#ids == 0) {
                    my ($status, @path_info) = runCommand("btrfs subvol list @{[$fs->mount]}");
                    if ($status != 0) {
                        die "Failed to find @{[$fs->mount]} subvolume id from btrfs\n";
                    }
                    my @paths = join("", @path_info) =~ m/ID $ids[0] [^\n]* path ([^\n]*)/;
                    if ($#paths > 0) {
                        die "Btrfs returned multiple paths for a single subvolume id, mountpoint @{[$fs->mount]}\n";
                    } elsif ($#paths != 0) {
                        die "Btrfs did not return a path for the subvolume at @{[$fs->mount]}\n";
                    }
                    $path = "/$paths[0]$path";
                }
            }
        }
        if (not $search eq "") {
            $search = "search --set=drive$driveid " . $search;
            $path = "(\$drive$driveid)$path";
            $driveid += 1;
        }
    }
    return Grub->new(path => $path, search => $search);
}
my $grubBoot = GrubFs("/boot");
my $grubStore;
if ($copyKernels == 0) {
    $grubStore = GrubFs("/nix/store");
}

# Generate the header.
my $conf .= "# Automatically generated.  DO NOT EDIT THIS FILE!\n";

if ($grubVersion == 1) {
    $conf .= "
        default $defaultEntry
        timeout $timeout
    ";
    if ($splashImage) {
        copy $splashImage, "/boot/background.xpm.gz" or die "cannot copy $splashImage to /boot\n";
        $conf .= "splashimage " . $grubBoot->path . "/background.xpm.gz\n";
    }
}

else {
    if ($copyKernels == 0) {
        $conf .= "
            " . $grubStore->search;
    }
    $conf .= "
        " . $grubBoot->search . "
        if [ -s \$prefix/grubenv ]; then
          load_env
        fi

        # ‘grub-reboot’ sets a one-time saved entry, which we process here and
        # then delete.
        if [ \"\${saved_entry}\" ]; then
          # The next line *has* to look exactly like this, otherwise KDM's
          # reboot feature won't work properly with GRUB 2.
          set default=\"\${saved_entry}\"
          set saved_entry=
          set prev_saved_entry=
          save_env saved_entry
          save_env prev_saved_entry
          set timeout=1
        else
          set default=$defaultEntry
          set timeout=$timeout
        fi

        if loadfont " . $grubBoot->path . "/grub/fonts/unicode.pf2; then
          set gfxmode=640x480
          insmod gfxterm
          insmod vbe
          terminal_output gfxterm
        fi
    ";

    if ($splashImage) {
        # FIXME: GRUB 1.97 doesn't resize the background image if it
        # doesn't match the video resolution.
        copy $splashImage, "/boot/background.png" or die "cannot copy $splashImage to /boot\n";
        $conf .= "
            insmod png
            if background_image " . $grubBoot->path . "/background.png; then
              set color_normal=white/black
              set color_highlight=black/white
            else
              set menu_color_normal=cyan/blue
              set menu_color_highlight=white/blue
            fi
        ";
    }
}

$conf .= "$extraConfig\n";


# Generate the menu entries.
$conf .= "\n";

my %copied;
mkpath("/boot/kernels", 0, 0755) if $copyKernels;

sub copyToKernelsDir {
    my ($path) = @_;
    return $grubStore->path . substr($path, length("/nix/store")) unless $copyKernels;
    $path =~ /\/nix\/store\/(.*)/ or die;
    my $name = $1; $name =~ s/\//-/g;
    my $dst = "/boot/kernels/$name";
    # Don't copy the file if $dst already exists.  This means that we
    # have to create $dst atomically to prevent partially copied
    # kernels or initrd if this script is ever interrupted.
    if (! -e $dst) {
        my $tmp = "$dst.tmp";
        copy $path, $tmp or die "cannot copy $path to $tmp\n";
        rename $tmp, $dst or die "cannot rename $tmp to $dst\n";
    }
    $copied{$dst} = 1;
    return $grubBoot->path . "/kernels/$name";
}

sub addEntry {
    my ($name, $path) = @_;
    return unless -e "$path/kernel" && -e "$path/initrd";

    my $kernel = copyToKernelsDir(Cwd::abs_path("$path/kernel"));
    my $initrd = copyToKernelsDir(Cwd::abs_path("$path/initrd"));
    my $xen = -e "$path/xen.gz" ? copyToKernelsDir(Cwd::abs_path("$path/xen.gz")) : undef;

    # FIXME: $confName

    my $kernelParams =
        "systemConfig=" . Cwd::abs_path($path) . " " .
        "init=" . Cwd::abs_path("$path/init") . " " .
        readFile("$path/kernel-params");
    my $xenParams = $xen && -e "$path/xen-params" ? readFile("$path/xen-params") : "";

    if ($grubVersion == 1) {
        $conf .= "title $name\n";
        $conf .= "  $extraPerEntryConfig\n" if $extraPerEntryConfig;
        $conf .= "  kernel $xen $xenParams\n" if $xen;
        $conf .= "  " . ($xen ? "module" : "kernel") . " $kernel $kernelParams\n";
        $conf .= "  " . ($xen ? "module" : "initrd") . " $initrd\n\n";
    } else {
        $conf .= "menuentry \"$name\" {\n";
        $conf .= $grubBoot->search . "\n";
        if ($copyKernels == 0) {
            $conf .= $grubStore->search . "\n";
        }
        $conf .= "  $extraPerEntryConfig\n" if $extraPerEntryConfig;
        $conf .= "  multiboot $xen $xenParams\n" if $xen;
        $conf .= "  " . ($xen ? "module" : "linux") . " $kernel $kernelParams\n";
        $conf .= "  " . ($xen ? "module" : "initrd") . " $initrd\n";
        $conf .= "}\n\n";
    }
}


# Add default entries.
$conf .= "$extraEntries\n" if $extraEntriesBeforeNixOS;

addEntry("NixOS - Default", $defaultConfig);

$conf .= "$extraEntries\n" unless $extraEntriesBeforeNixOS;

my $grubBootPath = $grubBoot->path;
# extraEntries could refer to @bootRoot@, which we have to substitute
$conf =~ s/\@bootRoot\@/$grubBootPath/g;

# Emit submenus for all system profiles.
sub addProfile {
    my ($profile, $description) = @_;

    # Add entries for all generations of this profile.
    $conf .= "submenu \"$description\" {\n" if $grubVersion == 2;

    sub nrFromGen { my ($x) = @_; $x =~ /\/\w+-(\d+)-link/; return $1; }

    my @links = sort
        { nrFromGen($b) <=> nrFromGen($a) }
        (glob "$profile-*-link");

    my $curEntry = 0;
    foreach my $link (@links) {
        last if $curEntry++ >= $configurationLimit;
        my $date = strftime("%F", localtime(lstat($link)->mtime));
        my $version =
            -e "$link/nixos-version"
            ? readFile("$link/nixos-version")
            : basename((glob(dirname(Cwd::abs_path("$link/kernel")) . "/lib/modules/*"))[0]);
        addEntry("NixOS - Configuration " . nrFromGen($link) . " ($date - $version)", $link);
    }

    $conf .= "}\n" if $grubVersion == 2;
}

addProfile "/nix/var/nix/profiles/system", "NixOS - All configurations";

if ($grubVersion == 2) {
    for my $profile (glob "/nix/var/nix/profiles/system-profiles/*") {
        my $name = basename($profile);
        next unless $name =~ /^\w+$/;
        addProfile $profile, "NixOS - Profile '$name'";
    }
}

# Run extraPrepareConfig in sh
if ($extraPrepareConfig ne "") {
  system((get("shell"), "-c", $extraPrepareConfig));
}

# Atomically update the GRUB config.
my $confFile = $grubVersion == 1 ? "/boot/grub/menu.lst" : "/boot/grub/grub.cfg";
my $tmpFile = $confFile . ".tmp";
writeFile($tmpFile, $conf);
rename $tmpFile, $confFile or die "cannot rename $tmpFile to $confFile\n";


# Remove obsolete files from /boot/kernels.
foreach my $fn (glob "/boot/kernels/*") {
    next if defined $copied{$fn};
    print STDERR "removing obsolete file $fn\n";
    unlink $fn;
}


# Install GRUB if the version changed from the last time we installed
# it.  FIXME: shouldn't we reinstall if ‘devices’ changed?
my $prevVersion = readFile("/boot/grub/version") // "";
if (($ENV{'NIXOS_INSTALL_GRUB'} // "") eq "1" || get("fullVersion") ne $prevVersion) {
    foreach my $dev ($dom->findnodes('/expr/attrs/attr[@name = "devices"]/list/string/@value')) {
        $dev = $dev->findvalue(".") or die;
        next if $dev eq "nodev";
        print STDERR "installing the GRUB $grubVersion boot loader on $dev...\n";
        system("$grub/sbin/grub-install", "--recheck", Cwd::abs_path($dev)) == 0
            or die "$0: installation of GRUB on $dev failed\n";
    }
    writeFile("/boot/grub/version", get("fullVersion"));
}
