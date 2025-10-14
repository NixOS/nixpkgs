use strict;
use feature 'signatures';
use Cwd 'abs_path';
use IO::Handle;
use File::Path;
use File::Basename;
use File::Compare;
use JSON::PP;

STDOUT->autoflush(1);

$SIG{__WARN__} = sub { warn "pkgs.buildEnv warning: ", @_ };
$SIG{__DIE__}  = sub { die "pkgs.buildEnv error: ", @_ };

my $out = $ENV{"out"};
my $extraPrefix = $ENV{"extraPrefix"};

my @pathsToLink = split /(?<!\\) /, $ENV{"pathsToLink"};
@pathsToLink = map { s/\\ / /g; $_ } @pathsToLink;

sub isInPathsToLink($path) {
    $path = "/" if $path eq "";
    foreach my $elem (@pathsToLink) {
        return 1 if
            $elem eq "/" ||
            (substr($path, 0, length($elem)) eq $elem
             && (($path eq $elem) || (substr($path, length($elem), 1) eq "/")));
    }
    return 0;
}

# Returns whether a path in one of the linked packages may contain
# files in one of the elements of pathsToLink.
sub hasPathsToLink($path) {
    foreach my $elem (@pathsToLink) {
        return 1 if
            $path eq "" ||
            (substr($elem, 0, length($path)) eq $path
             && (($path eq $elem) || (substr($elem, length($path), 1) eq "/")));
    }
    return 0;
}

# Similar to `lib.isStorePath`
sub isStorePath($path) {
    my $storePath = "@storeDir@";

    return substr($path, 0, 1) eq "/" && dirname($path) eq $storePath;
}

# For each activated package, determine what symlinks to create.

my %symlinks;

# Add all pathsToLink and all parent directories.
#
# For "/a/b/c" that will include
# [ "", "/a", "/a/b", "/a/b/c" ]
#
# That ensures the whole directory tree needed by pathsToLink is
# created as directories and not symlinks.
$symlinks{""} = ["", 0];
for my $p (@pathsToLink) {
    my @parts = split '/', $p;

    my $cur = "";
    for my $x (@parts) {
        $cur = $cur . "/$x";
        $cur = "" if $cur eq "/";
        $symlinks{$cur} = ["", 0];
    }
}

sub findFiles;

sub findFilesInDir($relName, $target, $ignoreCollisions, $checkCollisionContents, $priority, $ignoreSingleFileOutputs) {
    opendir DIR, "$target" or die "cannot open `$target': $!";
    my @names = readdir DIR or die;
    closedir DIR;

    foreach my $name (@names) {
        next if $name eq "." || $name eq "..";
        findFiles("$relName/$name", "$target/$name", $name, $ignoreCollisions, $checkCollisionContents, $priority, $ignoreSingleFileOutputs);
    }
}

sub checkCollision($path1, $path2) {
    if (! -e $path1 || ! -e $path2) {
        return 0;
    }

    my $stat1 = (stat($path1))[2];
    my $stat2 = (stat($path2))[2];

    if ($stat1 != $stat2) {
        warn "different permissions in `$path1' and `$path2': "
           . sprintf("%04o", $stat1 & 07777) . " <-> "
           . sprintf("%04o", $stat2 & 07777);
        return 0;
    }

    return compare($path1, $path2) == 0;
}

sub prependDangling($path) {
    return (-l $path && ! -e $path ? "dangling symlink " : "") . "`$path'";
}

sub findFiles($relName, $target, $baseName, $ignoreCollisions, $checkCollisionContents, $priority, $ignoreSingleFileOutputs) {
    # The store path must not be a file when not ignoreSingleFileOutputs
    if (-f $target && isStorePath $target) {
        if ($ignoreSingleFileOutputs) {
            warn "The store path $target is a file and can't be merged into an environment using pkgs.buildEnv, ignoring it";
            return;
        } else {
            die "The store path $target is a file and can't be merged into an environment using pkgs.buildEnv!";
        }
    }

    # Urgh, hacky...
    return if
        $relName eq "/propagated-build-inputs" ||
        $relName eq "/nix-support" ||
        $relName =~ /info\/dir$/ ||
        ( $relName =~ /^\/share\/mime\// && !( $relName =~ /^\/share\/mime\/packages/ ) ) ||
        $baseName eq "perllocal.pod" ||
        $baseName eq "log" ||
        ! (hasPathsToLink($relName) || isInPathsToLink($relName));

    my ($oldTarget, $oldPriority) = @{$symlinks{$relName} // [undef, undef]};

    # If target doesn't exist, create it. If it already exists as a
    # symlink to a file (not a directory) in a lower-priority package,
    # overwrite it.
    if (!defined $oldTarget || ($priority < $oldPriority && ($oldTarget ne "" && ! -d $oldTarget))) {
        # If target is a dangling symlink, emit a warning.
        if (-l $target && ! -e $target) {
            my $link = readlink $target;
            warn "creating dangling symlink `$out$extraPrefix/$relName' -> `$target' -> `$link'\n";
        }
        $symlinks{$relName} = [$target, $priority];
        return;
    }

    # If target already exists and both targets resolves to the same path, skip
    if (
        defined $oldTarget && $oldTarget ne "" &&
        defined abs_path($target) && defined abs_path($oldTarget) &&
        abs_path($target) eq abs_path($oldTarget)
    ) {
        # Prefer the target that is not a symlink, if any
        if (-l $oldTarget && ! -l $target) {
            $symlinks{$relName} = [$target, $priority];
        }
        return;
    }

    # If target already exists as a symlink to a file (not a
    # directory) in a higher-priority package, skip.
    if (defined $oldTarget && $priority > $oldPriority && $oldTarget ne "" && ! -d $oldTarget) {
        return;
    }

    # If target is supposed to be a directory but it isn't, die with an error message
    # instead of attempting to recurse into it, only to fail then.
    # This happens e.g. when pathsToLink contains a non-directory path.
    if ($oldTarget eq "" && ! -d $target) {
        die "not a directory: `$target'\n";
    }

    unless (-d $target && ($oldTarget eq "" || -d $oldTarget)) {
        # Prepend "dangling symlink" to paths if applicable.
        my $targetRef = prependDangling($target);
        my $oldTargetRef = prependDangling($oldTarget);

        if ($ignoreCollisions) {
            warn "colliding subpath (ignored): $targetRef and $oldTargetRef\n" if $ignoreCollisions == 1;
            return;
        } elsif ($checkCollisionContents && checkCollision($oldTarget, $target)) {
            return;
        } else {
            die "two given paths contain a conflicting subpath:\n  $targetRef and\n  $oldTargetRef\nhint: this may be caused by two different versions of the same package in buildEnv's `paths` parameter\nhint: `pkgs.nix-diff` can be used to compare derivations\n";
        }
    }

    findFilesInDir($relName, $oldTarget, $ignoreCollisions, $checkCollisionContents, $oldPriority, $ignoreSingleFileOutputs) unless $oldTarget eq "";
    findFilesInDir($relName, $target, $ignoreCollisions, $checkCollisionContents, $priority, $ignoreSingleFileOutputs);

    $symlinks{$relName} = ["", $priority]; # denotes directory
}


my %done;
my %postponed;

sub addPkg($pkgDir, $ignoreCollisions, $checkCollisionContents, $priority, $ignoreSingleFileOutputs) {
    return if (defined $done{$pkgDir});
    $done{$pkgDir} = 1;

    findFiles("", $pkgDir, "", $ignoreCollisions, $checkCollisionContents, $priority, $ignoreSingleFileOutputs);

    my $propagatedFN = "$pkgDir/nix-support/propagated-user-env-packages";
    if (-e $propagatedFN) {
        open PROP, "<$propagatedFN" or die;
        my $propagated = <PROP>;
        close PROP;
        my @propagated = split ' ', $propagated;
        foreach my $p (@propagated) {
            $postponed{$p} = 1 unless defined $done{$p};
        }
    }
}

# Read packages list.
my $pkgs;

if (exists $ENV{"pkgsPath"}) {
    open FILE, $ENV{"pkgsPath"};
    $pkgs = <FILE>;
    close FILE;
} else {
    $pkgs = $ENV{"pkgs"}
}

# Symlink to the packages that have been installed explicitly by the
# user.
for my $pkg (@{decode_json $pkgs}) {
    for my $path (@{$pkg->{paths}}) {
        addPkg($path,
               $ENV{"ignoreCollisions"} eq "1",
               $ENV{"checkCollisionContents"} eq "1",
               $pkg->{priority},
               $ENV{"ignoreSingleFileOutputs"} eq "1")
           if -e $path;
    }
}


# Symlink to the packages that have been "propagated" by packages
# installed by the user (i.e., package X declares that it wants Y
# installed as well).  We do these later because they have a lower
# priority in case of collisions.
my $priorityCounter = 1000; # don't care about collisions
while (scalar(keys %postponed) > 0) {
    my @pkgDirs = keys %postponed;
    %postponed = ();
    foreach my $pkgDir (sort @pkgDirs) {
        addPkg($pkgDir, 2, $ENV{"checkCollisionContents"} eq "1", $priorityCounter++, $ENV{"ignoreSingleFileOutputs"} eq "1");
    }
}

my $extraPathsFilePath = $ENV{"extraPathsFrom"};
if ($extraPathsFilePath) {
    open FILE, $extraPathsFilePath or die "cannot open extra paths file $extraPathsFilePath: $!";

    while(my $line = <FILE>) {
        chomp $line;
        addPkg($line,
               $ENV{"ignoreCollisions"} eq "1",
               $ENV{"checkCollisionContents"} eq "1",
               1000,
               $ENV{"ignoreSingleFileOutputs"} eq "1")
            if -d $line;
    }

    close FILE;
}

# Create the symlinks.
my $nrLinks = 0;
foreach my $relName (sort keys %symlinks) {
    my ($target, $priority) = @{$symlinks{$relName}};
    my $abs = "$out" . "$extraPrefix" . "/$relName";
    next unless isInPathsToLink $relName;
    if ($target eq "") {
        #print "creating directory $relName\n";
        mkpath $abs or die "cannot create directory `$abs': $!";
    } else {
        #print "creating symlink $relName to $target\n";
        symlink $target, $abs ||
            die "error creating link `$abs': $!";
        $nrLinks++;
    }
}


print STDERR "created $nrLinks symlinks in user environment\n";


my $manifest = $ENV{"manifest"};
if ($manifest) {
    symlink($manifest, "$out/manifest") or die "cannot create manifest";
}
