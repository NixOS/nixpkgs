#! /usr/bin/perl -w

use strict;


# Global settings.
my $releasesDir = "/home/eelco/public_html/test";

umask 0002;


sub printResult {
    my $result = shift;
    print "Content-Type: text/plain\n\n"; 
    print "$result\n"; 
}


my $args = $ENV{"PATH_INFO"};

# Parse command.
die unless $args =~ /^\/([a-z]+)\/(.*)$/;
my $command = $1;
$args = $2;


# Perform the command.

# Start creation of a release.
if ($command eq "create") {
    die unless $args =~ /^([A-Za-z0-9-][A-Za-z0-9-\.]*)$/;
    my $releaseName = $1;

    my $uniqueNr = int (rand 1000000);
    my $sessionName = "tmp-$uniqueNr-$releaseName";
    my $releaseDir = "$releasesDir/$sessionName";

    mkdir $releaseDir, 0775 or die "cannot create $releaseDir: $!";

    printResult "$sessionName";
}

# Upload a file to a release.
elsif ($command eq "upload") {
    die unless $args =~ /^([A-Za-z0-9-][A-Za-z0-9-\.]*)((\/[A-Za-z0-9-][A-Za-z0-9-\.]*)+)$/;
    my $sessionName = $1;
    my $path = $2;

    my $fullPath = "$releasesDir/$sessionName/$path";

    open OUT, ">$fullPath" or die "cannot create $fullPath: $!";
    while (<STDIN>) {
	print OUT "$_" or die;
    }
    close OUT or die;

    printResult "ok";
}

# Finish the release.
elsif ($command eq "finish") {
    die unless $args =~ /^([A-Za-z0-9-][A-Za-z0-9-\.]+)$/;
    my $sessionName = $1;

    die unless $sessionName =~ /^tmp-\d+-(.*)$/;
    my $releaseName = $1;

    my $releaseDir1 = "$releasesDir/$sessionName";
    my $releaseDir2 = "$releasesDir/$releaseName";
    if (-d $releaseDir2) {
	my $uniqueNr = int (rand 1000000);
	my $releaseDir3 = "$releasesDir/replaced-$uniqueNr-$releaseName";
	rename $releaseDir2, $releaseDir3
	    or die "cannot rename $releaseDir2 to $releaseDir3";
    }
    rename $releaseDir1, $releaseDir2
	or die "cannot rename $releaseDir1 to $releaseDir2";

    printResult "$releaseName";
}

# Check for release existence.
elsif ($command eq "exists") {
    die unless $args =~ /^([A-Za-z0-9-][A-Za-z0-9-\.]*)$/;
    my $releaseName = $1;

    my $releaseDir = "$releasesDir/$releaseName";

    if (-d $releaseDir) {
	printResult "yes";
    } else {
	printResult "no";
    }
}

else {
    die "invalid command";
}
