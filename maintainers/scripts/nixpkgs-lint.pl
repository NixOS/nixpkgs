#! /run/current-system/sw/bin/perl -w

use strict;
use List::Util qw(min);
use XML::Simple qw(:strict);
use Data::Dumper;

my $filter = "*";

my $xml = `nix-env -f . -qa '$filter' --xml --meta --drv-path`;

my $info = XMLin($xml, KeyAttr => { 'item' => '+attrPath', 'meta' => 'name' }, ForceArray => 1, SuppressEmpty => '' ) or die "cannot parse XML output";

#print Dumper($info);

my %pkgsByName;

foreach my $attr (sort keys %{$info->{item}}) {
    my $pkg = $info->{item}->{$attr};
    #print STDERR "attr = $attr, name = $pkg->{name}\n";
    $pkgsByName{$pkg->{name}} //= [];
    push @{$pkgsByName{$pkg->{name}}}, $pkg;
}

# Check meta information.
print "=== Package meta information ===\n\n";
my $nrMissingMaintainers = 0;
my $nrMissingDescriptions = 0;
my $nrBadDescriptions = 0;
my $nrMissingLicenses = 0;

foreach my $attr (sort keys %{$info->{item}}) {
    my $pkg = $info->{item}->{$attr};

    my $pkgName = $pkg->{name};
    $pkgName =~ s/-[0-9].*//;

    # Check the maintainers.
    my @maintainers;
    my $x = $pkg->{meta}->{maintainers};
    if (defined $x && $x->{type} eq "strings") {
        @maintainers = map { $_->{value} } @{$x->{string}};
    } elsif (defined $x->{value}) {
        @maintainers = ($x->{value});
    }

    if (scalar @maintainers == 0) {
        print "$attr: Lacks a maintainer\n";
        $nrMissingMaintainers++;
    }

    # Check the license.
    if (!defined $pkg->{meta}->{license}) {
        print "$attr: Lacks a license\n";
        $nrMissingLicenses++;
    }

    # Check the description.
    my $description = $pkg->{meta}->{description}->{value};
    if (!$description) {
        print "$attr: Lacks a description\n";
        $nrMissingDescriptions++;
    } else {
        my $bad = 0;
        if ($description =~ /^\s/) {
            print "$attr: Description starts with whitespace\n";
            $bad = 1;
        }
        if ($description =~ /\s$/) {
            print "$attr: Description ends with whitespace\n";
            $bad = 1;
        }
        if ($description =~ /\.$/) {
            print "$attr: Description ends with a period\n";
            $bad = 1;
        }
        if (index(lc($description), lc($attr)) != -1) {
            print "$attr: Description contains package name\n";
            $bad = 1;
        }
        $nrBadDescriptions++ if $bad;
    }
}
print "\n";

# Find packages that have the same name.
print "=== Package name collisions ===\n\n";

my $nrCollisions = 0;
foreach my $name (sort keys %pkgsByName) {
    my @pkgs = @{$pkgsByName{$name}};

    # Filter attributes that are aliases of each other (e.g. yield the
    # same derivation path).
    my %drvsSeen;
    @pkgs = grep { my $x = $drvsSeen{$_->{drvPath}}; $drvsSeen{$_->{drvPath}} = 1; !defined $x } @pkgs;

    # Filter packages that have a lower priority.
    my $highest = min (map { $_->{priority} // 0 } @pkgs);
    @pkgs = grep { ($_->{priority} // 0) == $highest } @pkgs;

    next if scalar @pkgs == 1;

    $nrCollisions++;
    print "The following attributes evaluate to a package named ‘$name’:\n";
    print "  ", join(", ", map { $_->{attrPath} } @pkgs), "\n\n";
}

print "=== Bottom line ===\n";
print "Number of packages: ", scalar(keys %{$info->{item}}), "\n";
print "Number of missing maintainers: $nrMissingMaintainers\n";
print "Number of missing licenses: $nrMissingLicenses\n";
print "Number of missing descriptions: $nrMissingDescriptions\n";
print "Number of bad descriptions: $nrBadDescriptions\n";
print "Number of name collisions: $nrCollisions\n";
