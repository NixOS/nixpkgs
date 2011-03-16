use strict;
use File::Basename;

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
        my $base = basename $storePath;
        print "localPath {\n";
        print "  StorePath: $storePath\n";
        print "  CopyFrom: /tmp/inst-store/$base\n";
        print "  References: ";
        foreach my $ref (@{$refs{$storePath}}) {
            print "$ref ";
        }
        print "\n";
        print "}\n";
    }
}

elsif ($ENV{"printRegistration"} eq "1") {
    # This is the format used by `nix-store --register-validity
    # --hash-given' / `nix-store --load-db'.
    foreach my $storePath (sort (keys %storePaths)) {
        print "$storePath\n";
        print "0000000000000000000000000000000000000000000000000000000000000000\n"; # !!! fix
        print "0\n"; # !!! fix	
        print "\n"; # don't care about preserving the deriver
        print scalar(@{$refs{$storePath}}), "\n";
        foreach my $ref (@{$refs{$storePath}}) {
            print "$ref\n";
        }
    }
}

else {
    foreach my $storePath (sort (keys %storePaths)) {
        print "$storePath\n";
    }
}
