#! /run/current-system/sw/bin/perl -w

use strict;
use CPANPLUS::Backend;
use YAML::XS;
use JSON;

my $module_name = $ARGV[0];
die "syntax: $0 <MODULE-NAME>\n" unless defined $module_name;

my $cb = CPANPLUS::Backend->new;

my @modules = $cb->search(type => "name", allow => [$module_name]);
die "module $module_name not found\n" if scalar @modules == 0;
die "multiple packages that match module $module_name\n" if scalar @modules > 1;
my $module = $modules[0];

sub pkg_to_attr {
    my ($pkg_name) = @_;
    my $attr_name = $pkg_name;
    $attr_name =~ s/-\d.*//; # strip version
    return "LWP" if $attr_name eq "libwww-perl";
    $attr_name =~ s/-//g;
    return $attr_name;
}

sub get_pkg_name {
    my ($module) = @_;
    my $pkg_name = $module->package;
    $pkg_name =~ s/\.tar.*//;
    $pkg_name =~ s/\.zip//;
    return $pkg_name;
}

my $pkg_name = get_pkg_name $module;
my $attr_name = pkg_to_attr $pkg_name;

print STDERR "attribute name: ", $attr_name, "\n";
print STDERR "module: ", $module->module, "\n";
print STDERR "version: ", $module->version, "\n";
print STDERR "package: ", $module->package, , " (", $pkg_name, ", ", $attr_name, ")\n";
print STDERR "path: ", $module->path, "\n";

my $tar_path = $module->fetch();
print STDERR "downloaded to: $tar_path\n";
print STDERR "sha-256: ", $module->status->checksum_value, "\n";

my $pkg_path = $module->extract();
print STDERR "unpacked to: $pkg_path\n";

my $meta;
if (-e "$pkg_path/META.yml") {
    eval {
        $meta = YAML::XS::LoadFile("$pkg_path/META.yml");
    };
    if ($@) {
        system("iconv -f windows-1252 -t utf-8 '$pkg_path/META.yml' > '$pkg_path/META.yml.tmp'");
        $meta = YAML::XS::LoadFile("$pkg_path/META.yml.tmp");
    }
} elsif (-e "$pkg_path/META.json") {
    local $/;
    open(my $fh, '<', "$pkg_path/META.json") or die;
    $meta = decode_json(<$fh>);
} else {
    warn "package has no META.yml or META.json\n";
}

print STDERR "metadata: ", encode_json($meta), "\n" if defined $meta;

# Map a module to the attribute corresponding to its package
# (e.g. HTML::HeadParser will be mapped to HTMLParser, because that
# module is in the HTML-Parser package).
sub module_to_pkg {
    my ($module_name) = @_;
    my @modules = $cb->search(type => "name", allow => [$module_name]);
    if (scalar @modules == 0) {
        # Fallback.
        $module_name =~ s/:://g;
        return $module_name;
    }
    my $module = $modules[0];
    my $attr_name = pkg_to_attr(get_pkg_name $module);
    print STDERR "mapped dep $module_name to $attr_name\n";
    return $attr_name;
}

sub get_deps {
    my ($type) = @_;
    my $deps;
    if (defined $meta->{prereqs}) {
        die "unimplemented";
    } elsif ($type eq "runtime") {
        $deps = $meta->{requires};
    } elsif ($type eq "configure") {
        $deps = $meta->{configure_requires};
    } elsif ($type eq "build") {
        $deps = $meta->{build_requires};
    }
    my @res;
    foreach my $n (keys %{$deps}) {
        next if $n eq "perl";
        # Hacky way to figure out if this module is part of Perl.
        if ($n !~ /^JSON/ && $n !~ /^YAML/ && $n !~ /^Module::Pluggable/) {
            eval "use $n;";
            if (!$@) {
                print STDERR "skipping Perl-builtin module $n\n";
                next;
            }
        }
        push @res, module_to_pkg($n);
    }
    return @res;
}

sub uniq {
    return keys %{{ map { $_ => 1 } @_ }};
}

my @build_deps = sort(uniq(get_deps("configure"), get_deps("build"), get_deps("test")));
print STDERR "build deps: @build_deps\n";

my @runtime_deps = sort(uniq(get_deps("runtime")));
print STDERR "runtime deps: @runtime_deps\n";

my $homepage = $meta->{resources}->{homepage};
print STDERR "homepage: $homepage\n" if defined $homepage;

my $description = $meta->{abstract};
if (defined $description) {
    $description = uc(substr($description, 0, 1)) . substr($description, 1); # capitalise first letter
    $description =~ s/\.$//; # remove period at the end
    $description =~ s/\s*$//;
    $description =~ s/^\s*//;
    print STDERR "description: $description\n";
}

my $license = $meta->{license};
if (defined $license) {
    $license = "perl5" if $license eq "perl_5";
    print STDERR "license: $license\n";
}

my $build_fun = -e "$pkg_path/Build.PL" && ! -e "$pkg_path/Makefile.PL" ? "buildPerlModule" : "buildPerlPackage";

print STDERR "===\n";

print <<EOF;
  $attr_name = $build_fun {
    name = "$pkg_name";
    src = fetchurl {
      url = mirror://cpan/${\$module->path}/${\$module->package};
      sha256 = "${\$module->status->checksum_value}";
    };
EOF
print <<EOF if scalar @build_deps > 0;
    buildInputs = [ @build_deps ];
EOF
print <<EOF if scalar @runtime_deps > 0;
    propagatedBuildInputs = [ @runtime_deps ];
EOF
print <<EOF;
    meta = {
EOF
print <<EOF if defined $homepage;
      homepage = $homepage;
EOF
print <<EOF if defined $description;
      description = "$description";
EOF
print <<EOF if defined $license;
      license = "$license";
EOF
print <<EOF;
    };
  };
EOF
