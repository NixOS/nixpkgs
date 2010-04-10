#! @perl@ -w

use strict;
use Cwd;
use IO::Handle;
use File::Path;
use File::Basename;

STDOUT->autoflush(1);

my $out = $ENV{"out"};
mkdir "$out", 0755 || die "error creating $out";


my $symlinks = 0;


my @pathsToLink = split ' ', $ENV{"pathsToLink"};

sub isInPathsToLink {
    my $path = shift;
    $path = "/" if $path eq "";
    foreach my $elem (@pathsToLink) {
        return 1 if substr($path, 0, length($elem)) eq $elem;
    }
    return 0;
}


sub symLinkMkdir {
    my $src = shift;
    my $dst = shift;
    my $dir = dirname $dst;
    mkpath $dir;
    symlink($src, $dst) ||
        die "error creating link `$dst': $!";
    $symlinks++;
}


# For each activated package, create symlinks.

sub createLinks {
    my $relName = shift;
    my $srcDir = shift;
    my $dstDir = shift;
    my $ignoreCollisions = shift;

    my @srcFiles = glob("$srcDir/*");

    foreach my $srcFile (@srcFiles) {
        my $baseName = $srcFile;
        $baseName =~ s/^.*\///g; # strip directory
        my $dstFile = "$dstDir/$baseName";
        my $relName2 = "$relName/$baseName";

        # Urgh, hacky...
        if ($srcFile =~ /\/propagated-build-inputs$/ ||
            $srcFile =~ /\/nix-support$/ ||
            $srcFile =~ /\/perllocal.pod$/ ||
            $srcFile =~ /\/info\/dir$/ ||
            $srcFile =~ /\/log$/)
        {
            # Do nothing.
        }

        elsif (-d $srcFile) {

            if (!isInPathsToLink($relName2)) {
                # This path is not in the list of paths to link, but
                # some of its children may be.
                createLinks($relName2, $srcFile, $dstFile, $ignoreCollisions);
                next;
            }
            
            lstat $dstFile;

            if (-d _) {
                createLinks($relName2, $srcFile, $dstFile, $ignoreCollisions);
            }

            elsif (-l _) {
                my $target = readlink $dstFile or die;
                if (!-d $target) {
                    die "collission between directory `$srcFile' and non-directory `$target'";
                }
                unlink $dstFile or die "error unlinking `$dstFile': $!";
                mkpath $dstFile;
                createLinks($relName2, $target, $dstFile, $ignoreCollisions);
                createLinks($relName2, $srcFile, $dstFile, $ignoreCollisions);
            }

            else {
                symLinkMkdir $srcFile, $dstFile;
            }
        }

        elsif (-l $dstFile) {
            if (!$ignoreCollisions) {
                my $target = readlink $dstFile;
                die "collission between `$srcFile' and `$target'";
            }
        }

        else {
            next unless isInPathsToLink($relName2);
            symLinkMkdir $srcFile, $dstFile;
        }
    }
}


my %done;
my %postponed;

sub addPkg;
sub addPkg {
    my $pkgDir = shift;
    my $ignoreCollisions = shift;

    return if (defined $done{$pkgDir});
    $done{$pkgDir} = 1;

#    print "symlinking $pkgDir\n";
    createLinks("", "$pkgDir", "$out", $ignoreCollisions);

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
    addPkg($pkgDir, $ENV{"ignoreCollisions"} eq "1");
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


print STDERR "created $symlinks symlinks in user environment\n";


my $manifest = $ENV{"manifest"};
if ($manifest ne "") {
    symlink($manifest, "$out/manifest") or die "cannot create manifest";
}


system("eval \"\$postBuild\"") == 0
    or die "post-build hook failed";
