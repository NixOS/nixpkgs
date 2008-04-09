use strict;
use XML::Simple;

my $packagesFile = shift @ARGV;
my $urlPrefix = shift @ARGV;
my @toplevelPkgs = @ARGV;

my $xml = XMLin($packagesFile, ForceArray => ['package', 'rpm:entry', 'file'], KeyAttr => ['name']) or die;
my $pkgs = $xml->{'package'};

print STDERR "file contains $xml->{packages} packages\n";


my %provides;
foreach my $pkgName (keys %{$pkgs}) {
    print STDERR "looking at $pkgName\n";
    my $pkg = $pkgs->{$pkgName};
    print STDERR keys %{$pkg->{format}->{'rpm:provides'}}, "\n";
    if (defined $pkg->{format}->{'rpm:provides'}) {
        my $provides = $pkg->{format}->{'rpm:provides'}->{'rpm:entry'};
        foreach my $req (keys %{$provides}) {
            #print STDERR "  provides $req\n";
            #die "multiple provides for $req" if defined $provides{$req};
            $provides{$req} = $pkgName;
        }
    }
    if (defined $pkg->{format}->{file}) {
        foreach my $file (@{$pkg->{format}->{file}}) {
          #print STDERR "  provides file $file\n";
          $provides{$file} = $pkgName;
        }
    }
}


my %donePkgs;
my @needed = ();

sub closePackage {
    my $pkgName = shift;

    return if defined $donePkgs{$pkgName};
    $donePkgs{$pkgName} = 1;
    
    print STDERR ">>> $pkgName\n";
    
    my $pkg = $pkgs->{$pkgName} or die "package $pkgName doesn't exist";

    my $requires = $pkg->{format}->{'rpm:requires'}->{'rpm:entry'} or die;

    my @deps = ();
    foreach my $req (keys %{$requires}) {
        next if $req =~ /^rpmlib\(/;
        print STDERR "  needs $req\n";
        my $provider = $provides{$req};
        if (!defined $provider) {
            print STDERR "    WARNING: no provider for $req\n";
            next;
        }
        print STDERR "    satisfied by $provider\n";
        push @deps, $provider; 
    }

    closePackage($_) foreach @deps;

    push @needed, $pkgName;
}


foreach my $pkgName (@toplevelPkgs) {
    closePackage $pkgName;
}


# Generate the output Nix expression.
print "# This is a generated file.  Do not modify!\n";
print "# Following are the RPM packages constituting the closure of: @toplevelPkgs\n\n";
print "{fetchurl}:\n\n";
print "[\n\n";

foreach my $pkgName (@needed) {
    my $pkg = $pkgs->{$pkgName};
    die if $pkg->{checksum}->{type} ne "sha";
    print "  (fetchurl {\n";
    print "    url = $urlPrefix/$pkg->{location}->{href};\n";
    print "    sha1 = \"$pkg->{checksum}->{content}\";\n";
    print "  })\n";
    print "\n";
}

print "]\n";
