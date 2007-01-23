use strict;

my %storePaths;

foreach my $graph (@ARGV) {
    open GRAPH, "<$graph" or die;

    while (<GRAPH>) {
        chomp;
        my $storePath = "$_";
        $storePaths{$storePath} = 1;

        my $deriver = <GRAPH>; chomp $deriver;
        my $count = <GRAPH>; chomp $count;

        for (my $i = 0; $i < $count; ++$i) {
            my $ref = <GRAPH>;
        }
    }
    
    close GRAPH;
}

foreach my $storePath (sort (keys %storePaths)) {
    print "$storePath\n";
}
