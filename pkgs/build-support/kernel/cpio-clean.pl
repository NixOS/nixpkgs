use strict;

# Make inode number, link info and mtime consistent in order to get a consistent hash.
#
# Author: Alexander Kjeldaas <ak@formalprivacy.com>

use Archive::Cpio;

my $cpio = Archive::Cpio->new;
my $IN = \*STDIN;
my $ino = 1;
my %ino_remap = {};
$cpio->read_with_handler($IN, sub {
        my ($e) = @_;
        $ino_remap{$e->{inode}} = $ino++ unless exists $ino_remap{$e->{inode}};
        $e->{inode} = $ino_remap{$e->{inode}};
        $e->{mtime} = 1;
	$cpio->write_one(\*STDOUT, $e);
    });
$cpio->write_trailer(\*STDOUT);
