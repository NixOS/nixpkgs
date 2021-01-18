#! /usr/bin/env nix-shell
#! nix-shell -i perl -p perl perlPackages.XMLSimple

use strict;
use List::Util qw(min);
use XML::Simple qw(:strict);
use Getopt::Long qw(:config gnu_getopt);

# Parse the command line.
my $path = "<nixpkgs>";
my $filter = "*";
my $maintainer;

sub showHelp {
    print <<EOF;
Usage: $0 [--package=NAME] [--maintainer=REGEXP] [--file=PATH]

Check Nixpkgs for common errors/problems.

  -p, --package        filter packages by name (default is ‘*’)
  -m, --maintainer     filter packages by maintainer (case-insensitive regexp)
  -f, --file           path to Nixpkgs (default is ‘<nixpkgs>’)

Examples:
  \$ nixpkgs-lint -f /my/nixpkgs -p firefox
  \$ nixpkgs-lint -f /my/nixpkgs -m eelco
EOF
    exit 0;
}

GetOptions("package|p=s" => \$filter,
           "maintainer|m=s" => \$maintainer,
           "file|f=s" => \$path,
           "help" => sub { showHelp() }
    ) or exit 1;

# Evaluate Nixpkgs into an XML representation.
my $xml = `nix-env -f '$path' --arg overlays '[]' -qa '$filter' --xml --meta --drv-path`;
die "$0: evaluation of ‘$path’ failed\n" if $? != 0;

my $info = XMLin($xml, KeyAttr => { 'item' => '+attrPath', 'meta' => 'name' }, ForceArray => 1, SuppressEmpty => '' ) or die "cannot parse XML output";

# Check meta information.
print "=== Package meta information ===\n\n";
my $nrBadNames = 0;
my $nrMissingMaintainers = 0;
my $nrMissingPlatforms = 0;
my $nrMissingDescriptions = 0;
my $nrBadDescriptions = 0;
my $nrMissingLicenses = 0;

foreach my $attr (sort keys %{$info->{item}}) {
    my $pkg = $info->{item}->{$attr};

    my $pkgName = $pkg->{name};
    my $pkgVersion = "";
    if ($pkgName =~ /(.*)(-[0-9].*)$/) {
        $pkgName = $1;
        $pkgVersion = $2;
    }

    # Check the maintainers.
    my @maintainers;
    my $x = $pkg->{meta}->{maintainers};
    if (defined $x && $x->{type} eq "strings") {
        @maintainers = map { $_->{value} } @{$x->{string}};
    } elsif (defined $x->{value}) {
        @maintainers = ($x->{value});
    }

    if (defined $maintainer && scalar(grep { $_ =~ /$maintainer/i } @maintainers) == 0) {
        delete $info->{item}->{$attr};
        next;
    }

    if (scalar @maintainers == 0) {
        print "$attr: Lacks a maintainer\n";
        $nrMissingMaintainers++;
    }

    # Check the platforms.
    if (!defined $pkg->{meta}->{platforms}) {
        print "$attr: Lacks a platform\n";
        $nrMissingPlatforms++;
    }

    # Package names should not be capitalised.
    if ($pkgName =~ /^[A-Z]/) {
        print "$attr: package name ‘$pkgName’ should not be capitalised\n";
        $nrBadNames++;
    }

    if ($pkgVersion eq "") {
        print "$attr: package has no version\n";
        $nrBadNames++;
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

my %pkgsByName;

foreach my $attr (sort keys %{$info->{item}}) {
    my $pkg = $info->{item}->{$attr};
    #print STDERR "attr = $attr, name = $pkg->{name}\n";
    $pkgsByName{$pkg->{name}} //= [];
    push @{$pkgsByName{$pkg->{name}}}, $pkg;
}

my $nrCollisions = 0;
foreach my $name (sort keys %pkgsByName) {
    my @pkgs = @{$pkgsByName{$name}};

    # Filter attributes that are aliases of each other (e.g. yield the
    # same derivation path).
    my %drvsSeen;
    @pkgs = grep { my $x = $drvsSeen{$_->{drvPath}}; $drvsSeen{$_->{drvPath}} = 1; !defined $x } @pkgs;

    # Filter packages that have a lower priority.
    my $highest = min (map { $_->{meta}->{priority}->{value} // 0 } @pkgs);
    @pkgs = grep { ($_->{meta}->{priority}->{value} // 0) == $highest } @pkgs;

    next if scalar @pkgs == 1;

    $nrCollisions++;
    print "The following attributes evaluate to a package named ‘$name’:\n";
    print "  ", join(", ", map { $_->{attrPath} } @pkgs), "\n\n";
}

print "=== Bottom line ===\n";
print "Number of packages: ", scalar(keys %{$info->{item}}), "\n";
print "Number of bad names: $nrBadNames\n";
print "Number of missing maintainers: $nrMissingMaintainers\n";
print "Number of missing platforms: $nrMissingPlatforms\n";
print "Number of missing licenses: $nrMissingLicenses\n";
print "Number of missing descriptions: $nrMissingDescriptions\n";
print "Number of bad descriptions: $nrBadDescriptions\n";
print "Number of name collisions: $nrCollisions\n";
