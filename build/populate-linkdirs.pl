#! /usr/bin/perl -w

use strict;
use Cwd;

my $selfdir = cwd;

my @dirs = ("bin", "sbin", "lib", "include");

# Create the subdirectories.
mkdir $selfdir;
foreach my $dir (@dirs) {
    mkdir "$selfdir/$dir";
}

# For each activated package, create symlinks.

sub createLinks {
    my $srcdir = shift;
    my $dstdir = shift;

    my @srcfiles = glob("$srcdir/*");

    foreach my $srcfile (@srcfiles) {
	my $basename = $srcfile;
	$basename =~ s/^.*\///g; # strip directory
	my $dstfile = "$dstdir/$basename";
	if (-d $srcfile) {
	    # !!! hack for resolving name clashes
	    if (!-e $dstfile) {
		mkdir($dstfile) or 
		    die "error creating directory $dstfile";
	    }
	    -d $dstfile or die "$dstfile is not a directory";
	    createLinks($srcfile, $dstfile);
	} elsif (-l $dstfile) {
	    my $target = readlink($dstfile);
	    die "collission between $srcfile and $target";
	} else {
	    print "linking $dstfile to $srcfile\n";
	    symlink($srcfile, $dstfile) or
		die "error creating link $dstfile";
	}
    }
}

foreach my $name (keys %ENV) {

    next unless ($name =~ /^act.*$/);

    my $pkgdir = $ENV{$name};

    print "merging $pkgdir\n";

    foreach my $dir (@dirs) {
	createLinks("$pkgdir/$dir", "$selfdir/$dir");
    }
}
