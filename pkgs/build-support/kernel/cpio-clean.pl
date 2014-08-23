use strict;

# Make inode number, link info and mtime consistent in order to get a consistent hash.
#
# Author: Alexander Kjeldaas <ak@formalprivacy.com>

use Archive::Cpio;

my $cpio = Archive::Cpio->new;
my $IN = \*STDIN;
my $ino = 1;
$cpio->read_with_handler($IN, sub {
        my ($e) = @_;
        $e->{mtime} = 1;
	$cpio->write_one(\*STDOUT, $e);
    });
$cpio->write_trailer(\*STDOUT);
