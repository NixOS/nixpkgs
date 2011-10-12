use strict;
use XML::Simple;

my @packagesFiles = ();
my @urlPrefixes = ();

# rpm-closure.pl (<package-file> <url-prefix>)+ <toplevel-pkg>+

while(-f $ARGV[0]) {
    my $packagesFile = shift @ARGV;
    my $urlPrefix = shift @ARGV;
    push(@packagesFiles, $packagesFile);
    push(@urlPrefixes, $urlPrefix);
}

my @toplevelPkgs = @ARGV;

my @archs = split ' ', ($ENV{'archs'} or "");

my %pkgs;
for (my $i = 0; $i < scalar(@packagesFiles); $i++) {
    my $packagesFile = $packagesFiles[$i];
    print STDERR "parsing packages in $packagesFile...\n";

    my $xml = XMLin($packagesFile, ForceArray => ['package', 'rpm:entry', 'file'], KeyAttr => []) or die;

    print STDERR "$packagesFile contains $xml->{packages} packages\n";

    foreach my $pkg (@{$xml->{'package'}}) {
        if (scalar @archs > 0) {
            my $arch = $pkg->{arch};
            my $found = 0;
            foreach my $a (@archs) { $found = 1 if $arch eq $a; }
            next if !$found;
        }
        if (defined $pkgs{$pkg->{name}}) {
            my $earlierPkg = $pkgs{$pkg->{name}};
            print STDERR "WARNING: duplicate occurrence of package $pkg->{name}\n";
            if ($earlierPkg->{'time'}->{file} <= $pkg->{'time'}->{file}) {
                print STDERR "WARNING: replaced package $pkg->{name} with newer one\n";
                $pkg->{urlPrefix} = $urlPrefixes[$i];
                $pkgs{$pkg->{name}} = $pkg;
            }
            next;
        }
        $pkg->{urlPrefix} = $urlPrefixes[$i];
        $pkgs{$pkg->{name}} = $pkg;
    }
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

    my $requires = $pkg->{format}->{'rpm:requires'}->{'rpm:entry'} || [];

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
    print "  (fetchurl {\n";
    print "    url = $pkg->{urlPrefix}/$pkg->{location}->{href};\n";
    if ($pkg->{checksum}->{type} eq "sha") {
        print "    sha1 = \"$pkg->{checksum}->{content}\";\n";
    } elsif ($pkg->{checksum}->{type} eq "sha256") {
        print "    sha256 = \"$pkg->{checksum}->{content}\";\n";
    } else {
        die "unsupported hash type";
    }
    print "  })\n";
    print "\n";
}

print "]\n";
