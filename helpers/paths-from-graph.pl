use strict;

my %storePaths;
my %refs;

foreach my $graph (@ARGV) {
    open GRAPH, "<$graph" or die;

    while (<GRAPH>) {
        chomp;
        my $storePath = "$_";
        $storePaths{$storePath} = 1;

        my $deriver = <GRAPH>; chomp $deriver;
        my $count = <GRAPH>; chomp $count;

        my @refs = ();
        for (my $i = 0; $i < $count; ++$i) {
            my $ref = <GRAPH>; chomp $ref;
            push @refs, $ref;
        }
        $refs{$storePath} = \@refs;
        
    }
    
    close GRAPH;
}


if ($ENV{"printManifest"} eq "1") {
    print "version {\n";
    print "  ManifestVersion: 3\n";
    print "}\n";

    foreach my $storePath (sort (keys %storePaths)) {
        print "localPath {\n";
        print "  StorePath: $storePath\n";
        print "  CopyFrom: /tmp/inst-store$storePath\n";
        print "  References: ";
        foreach my $ref (@{$refs{$storePath}}) {
            print "$ref ";
        }
        print "\n";
        print "}\n";
    }
}

else {
    foreach my $storePath (sort (keys %storePaths)) {
        print "$storePath\n";
    }
}
