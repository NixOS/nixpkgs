#! @perl@ -w

use strict;

my @paths = split ' ', $ENV{"ALL_INPUTS"};

open IN, "<$ARGV[0]" or die;
open OUT, ">$ARGV[0].tmp" or die;

while (<IN>) {
    # !!! should use a real XML library here.
    if (!/<dllmap dll="(.*)" target="(.*)"\/>/) {
        print OUT;
        next;
    }
    my $dll = $1;
    my $target = $2;

    foreach my $path (@paths) {
        my $fullPath = "$path/lib/$target";
        if (-e "$fullPath") {
            $target = $fullPath;
            last;
        }
    }

    print OUT "  <dllmap dll=\"$dll\" target=\"$target\"/>\n";
}

close IN;

rename "$ARGV[0].tmp", "$ARGV[0]" or die "cannot rename $ARGV[0]";
