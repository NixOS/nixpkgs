#! /usr/bin/perl -w

use strict;

my %map;
open LIST1, "<$ARGV[0]" or die;
while (<LIST1>) {
    /^(\S+)\s+(.*)$/;
    $map{$1} = $2;
}

open LIST1, "<$ARGV[1]" or die;
while (<LIST1>) {
    /^(\S+)\s+(.*)$/;
    if (!defined $map{$1}) {
        print STDERR "missing file: $2\n";
        next;
    }
    print "$2\n";
    print "$map{$1}\n";
}

