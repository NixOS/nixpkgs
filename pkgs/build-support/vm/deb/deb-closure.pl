use strict;
use Dpkg::Control;
use Dpkg::Deps;
use File::Basename;

my $packagesFile = shift @ARGV;
my $urlPrefix = shift @ARGV;
my @toplevelPkgs = @ARGV;


my %packages;


# Parse the Packages file.
open PACKAGES, "<$packagesFile" or die;

while (1) {
    my $cdata = Dpkg::Control->new(type => CTRL_INFO_PKG);
    last if not $cdata->parse(\*PACKAGES, $packagesFile);
    die unless defined $cdata->{Package};
    #print STDERR $cdata->{Package}, "\n";
    $packages{$cdata->{Package}} = $cdata;
}

close PACKAGES;


# Flatten a Dpkg::Deps dependency value into a list of package names.
sub getDeps {
    my $deps = shift;
    #print "$deps\n";
    if ($deps->isa('Dpkg::Deps::AND')) {
        my @res = ();
        foreach my $dep ($deps->get_deps()) {
            push @res, getDeps($dep);
        }
        return @res;
    } elsif ($deps->isa('Dpkg::Deps::OR')) {
        # Arbitrarily pick the first alternative.
        return getDeps(($deps->get_deps())[0]);
    } elsif ($deps->isa('Dpkg::Deps::Simple')) {
        return ($deps->{package});
    } else {
        die "unknown dep type";
    }
}


# Process the "Provides" fields to be able to resolve virtual dependencies.
my %provides;

foreach my $cdata (values %packages) {
    next unless defined $cdata->{Provides};
    my @provides = getDeps(Dpkg::Deps::deps_parse($cdata->{Provides}));
    foreach my $name (@provides) {
        #die "conflicting provide: $name\n" if defined $provides{$name};
        #warn "provide by $cdata->{Package} conflicts with package with the same name: $name\n";
        next if defined $packages{$name};
        $provides{$name} = $cdata->{Package};
    }
}


# Determine the closure of a package.
my %donePkgs;
my %depsUsed;
my @order = ();

sub closePackage {
    my $pkgName = shift;
    print STDERR ">>> $pkgName\n";
    my $cdata = $packages{$pkgName};

    if (!defined $cdata) {
        die "unknown (virtual) package $pkgName"
            unless defined $provides{$pkgName};
        print STDERR "virtual $pkgName: using $provides{$pkgName}\n";
        $pkgName = $provides{$pkgName};
        $cdata = $packages{$pkgName};
    }

    die "unknown package $pkgName" unless defined $cdata;
    return if defined $donePkgs{$pkgName};
    $donePkgs{$pkgName} = 1;

    if (defined $cdata->{Provides}) {
        foreach my $name (getDeps(Dpkg::Deps::deps_parse($cdata->{Provides}))) {
            $provides{$name} = $cdata->{Package};
        }
    }

    my @depNames = ();

    if (defined $cdata->{Depends}) {
        print STDERR "    $pkgName: $cdata->{Depends}\n";
        my $deps = Dpkg::Deps::deps_parse($cdata->{Depends});
        die unless defined $deps;
        push @depNames, getDeps($deps);
    }

    if (defined $cdata->{'Pre-Depends'}) {
        print STDERR "    $pkgName: $cdata->{'Pre-Depends'}\n";
        my $deps = Dpkg::Deps::deps_parse($cdata->{'Pre-Depends'});
        die unless defined $deps;
        push @depNames, getDeps($deps);
    }

    foreach my $depName (@depNames) {
        closePackage($depName);
    }

    push @order, $pkgName;
    $depsUsed{$pkgName} = \@depNames;
}

foreach my $pkgName (@toplevelPkgs) {
    closePackage $pkgName;
}


# Generate the output Nix expression.
print "# This is a generated file.  Do not modify!\n";
print "# Following are the Debian packages constituting the closure of: @toplevelPkgs\n\n";
print "{fetchurl}:\n\n";
print "[\n\n";

# Output the packages in strongly connected components.
my %done;
my %forward;
my $newComponent = 1;
foreach my $pkgName (@order) {
    $done{$pkgName} = 1;
    my $cdata = $packages{$pkgName};
    my @deps = @{$depsUsed{$pkgName}};
    foreach my $dep (@deps) {
        $dep = $provides{$dep} if defined $provides{$dep};
        $forward{$dep} = 1 unless defined $done{$dep};
    }
    delete $forward{$pkgName};

    print "  [\n\n" if $newComponent;
    $newComponent = 0;

    my $origName = basename $cdata->{Filename};
    my $cleanedName = $origName;
    $cleanedName =~ s/~//g;

    print "    (fetchurl {\n";
    print "      url = $urlPrefix/$cdata->{Filename};\n";
    print "      sha256 = \"$cdata->{SHA256}\";\n";
    print "      name = \"$cleanedName\";\n" if $cleanedName ne $origName;
    print "    })\n";
    print "\n";

    if (keys %forward == 0) {
        print "  ]\n\n";
        $newComponent = 1;
    }
}

foreach my $pkgName (@order) {
    my $cdata = $packages{$pkgName};
}

print "]\n";

if ($newComponent != 1) {
    print STDERR "argh: ", keys %forward, "\n";
    exit 1;
}
