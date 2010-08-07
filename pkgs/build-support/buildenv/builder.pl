#! @perl@ -w

use strict;
use Cwd 'abs_path';
use IO::Handle;
use File::Path;
use File::Basename;

STDOUT->autoflush(1);

my $out = $ENV{"out"};


my @pathsToLink = split ' ', $ENV{"pathsToLink"};

sub isInPathsToLink {
    my $path = shift;
    $path = "/" if $path eq "";
    foreach my $elem (@pathsToLink) {
        return 1 if substr($path, 0, length($elem)) eq $elem;
    }
    return 0;
}


# For each activated package, determine what symlinks to create.

my %symlinks;
$symlinks{""} = ""; # create root directory

sub findFiles;

sub findFilesInDir {
    my ($relName, $target, $ignoreCollisions) = @_;

    opendir DIR, "$target" or die "cannot open `$target': $!";
    my @names = readdir DIR or die;
    closedir DIR;
    
    foreach my $name (@names) {
        next if $name eq "." || $name eq "..";
        findFiles("$relName/$name", "$target/$name", $name, $ignoreCollisions);
    }
}
    
sub findFiles {
    my ($relName, $target, $baseName, $ignoreCollisions) = @_;

    # Urgh, hacky...
    return if
        $relName eq "/propagated-build-inputs" ||
        $relName eq "/nix-support" ||
        $relName =~ /info\/dir/ ||
        ( $relName =~ /^\/share\/mime\// && !( $relName =~ /^\/share\/mime\/packages/ ) ) ||
        $baseName eq "perllocal.pod" ||
        $baseName eq "log";

    my $oldTarget = $symlinks{$relName};

    if (!defined $oldTarget) {
        $symlinks{$relName} = $target;
        return;
    }

    unless (-d $target && ($oldTarget eq "" || -d $oldTarget)) {
        if ($ignoreCollisions) {
            warn "collision between `$target' and `$oldTarget'";
            return;
        } else {
            die "collision between `$target' and `$oldTarget'";
        }
    }

    findFilesInDir($relName, $oldTarget, $ignoreCollisions) unless $oldTarget eq "";
    findFilesInDir($relName, $target, $ignoreCollisions);
    
    $symlinks{$relName} = ""; # denotes directory
}


my %done;
my %postponed;

sub addPkg;
sub addPkg($;$) {
    my $pkgDir = shift;
    my $ignoreCollisions = shift;

    return if (defined $done{$pkgDir});
    $done{$pkgDir} = 1;

    findFiles("", "$pkgDir", "", $ignoreCollisions);

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


# Symlink to the packages that have been installed explicitly by the user.
my @args = split ' ', $ENV{"paths"};

foreach my $pkgDir (@args) {
    addPkg($pkgDir, $ENV{"ignoreCollisions"} eq "1") if -e $pkgDir;
}


# Symlink to the packages that have been "propagated" by packages
# installed by the user (i.e., package X declares that it want Y
# installed as well).  We do these later because they have a lower
# priority in case of collisions.
while (scalar(keys %postponed) > 0) {
    my @pkgDirs = keys %postponed;
    %postponed = ();
    foreach my $pkgDir (sort @pkgDirs) {
        addPkg($pkgDir, 1);
    }
}


# Create the symlinks.
my $nrLinks = 0;
foreach my $relName (sort keys %symlinks) {
    my $target = $symlinks{$relName};
    my $abs = "$out/$relName";
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


system("eval \"\$postBuild\"") == 0
    or die "post-build hook failed";
