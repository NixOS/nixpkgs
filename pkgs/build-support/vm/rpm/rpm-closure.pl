use strict;
use XML::Simple;

my $packagesFile = shift @ARGV;
my $urlPrefix = shift @ARGV;
my @toplevelPkgs = @ARGV;

my @archs = split ' ', ($ENV{'archs'} or "");

print STDERR "parsing packages...\n";

my $xml = XMLin($packagesFile, ForceArray => ['package', 'rpm:entry', 'file'], KeyAttr => []) or die;

print STDERR "file contains $xml->{packages} packages\n";


my %pkgs;
foreach my $pkg (@{$xml->{'package'}}) {
    if (scalar @archs > 0) {
        my $arch = $pkg->{arch};
        my $found = 0;
        foreach my $a (@archs) { $found = 1 if $arch eq $a; }
        next if !$found;
    }
    if (defined $pkgs{$pkg->{name}}) {
        print STDERR "WARNING: duplicate occurrence of package $pkg->{name}\n";
        next;
    }
    $pkgs{$pkg->{name}} = $pkg;
}


my %provides;
foreach my $pkgName (keys %pkgs) {
    print STDERR "looking at $pkgName\n";
    my $pkg = $pkgs{$pkgName};
    
    #print STDERR keys %{$pkg->{format}}, "\n";

    #print STDERR $pkg->{format}->{'rpm:provides'}, "\n";
    
    my $provides = $pkg->{format}->{'rpm:provides'}->{'rpm:entry'} or die;
    foreach my $req (@{$provides}) {
        #print "$req->{name}\n";
        #print STDERR "  provides $req\n";
        #die "multiple provides for $req" if defined $provides{$req};
        $provides{$req->{name}} = $pkgName;
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
    
    my $pkg = $pkgs{$pkgName} or die "package $pkgName doesn't exist";

    my $requires = $pkg->{format}->{'rpm:requires'}->{'rpm:entry'} or die;

    my @deps = ();
    foreach my $req (@{$requires}) {
        next if $req->{name} =~ /^rpmlib\(/;
        print STDERR "  needs $req->{name}\n";
        my $provider = $provides{$req->{name}};
        if (!defined $provider) {
            print STDERR "    WARNING: no provider for $req->{name}\n";
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
    my $pkg = $pkgs{$pkgName};
    die if $pkg->{checksum}->{type} ne "sha";
    print "  (fetchurl {\n";
    print "    url = $urlPrefix/$pkg->{location}->{href};\n";
    print "    sha1 = \"$pkg->{checksum}->{content}\";\n";
    print "  })\n";
    print "\n";
}

print "]\n";
