#!/usr/bin/env perl

use utf8;
use strict;
use warnings;

use CPAN::Meta();
use CPANPLUS::Backend();
use Getopt::Long::Descriptive qw( describe_options );
use JSON::PP qw( encode_json );
use Log::Log4perl qw(:easy);
use Readonly();

# Readonly hash that maps CPAN style license strings to information
# necessary to generate a Nixpkgs style license attribute.
Readonly::Hash my %LICENSE_MAP => (

    # The Perl 5 License (Artistic 1 & GPL 1 or later).
    perl_5 => {
        licenses => [qw( artistic1 gpl1Plus )]
    },

    # GNU Affero General Public License, Version 3.
    agpl_3 => {
        licenses => [qw( agpl3Plus )],
        amb      => 1
    },

    # Apache Software License, Version 1.1.
    apache_1_1 => {
        licenses => ["Apache License 1.1"],
        in_set   => 0
    },

    # Apache License, Version 2.0.
    apache_2_0 => {
        licenses => [qw( asl20 )]
    },

    # Artistic License, (Version 1).
    artistic_1 => {
        licenses => [qw( artistic1 )]
    },

    # Artistic License, Version 2.0.
    artistic_2 => {
        licenses => [qw( artistic2 )]
    },

    # BSD License (three-clause).
    bsd => {
        licenses => [qw( bsd3 )],
        amb      => 1
    },

    # FreeBSD License (two-clause).
    freebsd => {
        licenses => [qw( bsd2 )]
    },

    # GNU Free Documentation License, Version 1.2.
    gfdl_1_2 => {
        licenses => [qw( fdl12 )]
    },

    # GNU Free Documentation License, Version 1.3.
    gfdl_1_3 => {
        licenses => [qw( fdl13 )]
    },

    # GNU General Public License, Version 1.
    gpl_1 => {
        licenses => [qw( gpl1Plus )],
        amb      => 1
    },

    # GNU General Public License, Version 2. Note, we will interpret
    # "gpl" alone as GPL v2+.
    gpl_2 => {
        licenses => [qw( gpl2Plus )],
        amb      => 1
    },

    # GNU General Public License, Version 3.
    gpl_3 => {
        licenses => [qw( gpl3Plus )],
        amb      => 1
    },

    # GNU Lesser General Public License, Version 2.1. Note, we will
    # interpret "gpl" alone as LGPL v2.1+.
    lgpl_2_1 => {
        licenses => [qw( lgpl21Plus )],
        amb      => 1
    },

    # GNU Lesser General Public License, Version 3.0.
    lgpl_3_0 => {
        licenses => [qw( lgpl3Plus )],
        amb      => 1
    },

    # MIT (aka X11) License.
    mit => {
        licenses => [qw( mit )]
    },

    # Mozilla Public License, Version 1.0.
    mozilla_1_0 => {
        licenses => [qw( mpl10 )]
    },

    # Mozilla Public License, Version 1.1.
    mozilla_1_1 => {
        licenses => [qw( mpl11 )]
    },

    # OpenSSL License.
    openssl => {
        licenses => [qw( openssl )]
    },

    # Q Public License, Version 1.0.
    qpl_1_0 => {
        licenses => [qw( qpl )]
    },

    # Original SSLeay License.
    ssleay => {
        licenses => ["Original SSLeay License"],
        in_set   => 0
    },

    # Sun Internet Standards Source License (SISSL).
    sun => {
        licenses => ["Sun Industry Standards Source License v1.1"],
        in_set   => 0
    },

    # zlib License.
    zlib => {
        licenses => [qw( zlib )]
    },

    # Other Open Source Initiative (OSI) approved license.
    open_source => {
        licenses => [qw( free )],
        amb      => 1
    },

    # Requires special permission from copyright holder.
    restricted => {
        licenses => [qw( unfree )],
        amb      => 1
    },

    # Not an OSI approved license, but not restricted. Note, we
    # currently map this to unfreeRedistributable, which is a
    # conservative choice.
    unrestricted => {
        licenses => [qw( unfreeRedistributable )],
        amb      => 1
    },

    # License not provided in metadata.
    unknown => {
        licenses => [qw( unknown )],
        amb      => 1
    }
);

sub handle_opts {
    my ( $opt, $usage ) = describe_options(
        'usage: $0 %o MODULE',
        [ 'maintainer|m=s', 'the package maintainer' ],
        [ 'debug|d',        'enable debug output' ],
        [ 'help',           'print usage message and exit' ]
    );

    if ( $opt->help ) {
        print $usage->text;
        exit;
    }

    my $module_name = $ARGV[0];

    if ( !defined $module_name ) {
        print STDERR "Missing module name\n";
        print STDERR $usage->text;
        exit 1;
    }

    return ( $opt, $module_name );
}

# Takes a Perl package attribute name and returns 1 if the name cannot
# be referred to as a bareword. This typically happens if the package
# name is a reserved Nix keyword.
sub is_reserved {
    my ($pkg) = @_;

    return $pkg =~ /^(?: assert    |
                         else      |
                         if        |
                         import    |
                         in        |
                         inherit   |
                         let       |
                         rec       |
                         then      |
                         while     |
                         with      )$/x;
}

sub pkg_to_attr {
    my ($module) = @_;
    my $attr_name = $module->package_name;
    if ( $attr_name eq "libwww-perl" ) {
        return "LWP";
    }
    else {
        $attr_name =~ s/-//g;
        return $attr_name;
    }
}

sub get_pkg_name {
    my ($module) = @_;
    return $module->package_name . '-' . $module->package_version;
}

sub read_meta {
    my ($pkg_path) = @_;

    my $yaml_path = "$pkg_path/META.yml";
    my $json_path = "$pkg_path/META.json";
    my $meta;

    if ( -r $json_path ) {
        $meta = CPAN::Meta->load_file($json_path);
    }
    elsif ( -r $yaml_path ) {
        $meta = CPAN::Meta->load_file($yaml_path);
    }
    else {
        WARN("package has no META.yml or META.json");
    }

    return $meta;
}

# Map a module to the attribute corresponding to its package
# (e.g. HTML::HeadParser will be mapped to HTMLParser, because that
# module is in the HTML-Parser package).
sub module_to_pkg {
    my ( $cb, $module_name ) = @_;
    my @modules = $cb->search( type => "name", allow => [$module_name] );
    if ( scalar @modules == 0 ) {

        # Fallback.
        $module_name =~ s/:://g;
        return $module_name;
    }
    my $module    = $modules[0];
    my $attr_name = pkg_to_attr($module);
    DEBUG("mapped dep $module_name to $attr_name");
    return $attr_name;
}

sub get_deps {
    my ( $cb, $meta, $type ) = @_;

    return if !defined $meta;

    my $prereqs = $meta->effective_prereqs;
    my $deps = $prereqs->requirements_for( $type, "requires" );
    my @res;
    foreach my $n ( $deps->required_modules ) {
        next if $n eq "perl";

        # Figure out whether the module is a core module by attempting
        # to `use` the module in a pure Perl interpreter and checking
        # whether it succeeded. Note, $^X is a magic variable holding
        # the path to the running Perl interpreter.
        if ( system("env -i $^X -M$n -e1 >/dev/null 2>&1") == 0 ) {
            DEBUG("skipping Perl-builtin module $n");
            next;
        }

        my $pkg = module_to_pkg( $cb, $n );

        # If the package name is reserved then we need to refer to it
        # through the "self" variable.
        $pkg = "self.\"$pkg\"" if is_reserved($pkg);

        push @res, $pkg;
    }
    return @res;
}

sub uniq {
    return keys %{ { map { $_ => 1 } @_ } };
}

sub render_license {
    my ($cpan_license) = @_;

    return if !defined $cpan_license;

    my $licenses;

    # If the license is ambiguous then we'll print an extra warning.
    # For example, "gpl_2" is ambiguous since it may refer to exactly
    # "GPL v2" or to "GPL v2 or later".
    my $amb = 0;

    # Whether the license is available inside `stdenv.lib.licenses`.
    my $in_set = 1;

    my $nix_license = $LICENSE_MAP{$cpan_license};
    if ( !$nix_license ) {
        WARN("Unknown license: $cpan_license");
        $licenses = [$cpan_license];
        $in_set   = 0;
    }
    else {
        $licenses = $nix_license->{licenses};
        $amb      = $nix_license->{amb};
        $in_set   = !$nix_license->{in_set};
    }

    my $license_line;

    if ( @$licenses == 0 ) {

        # Avoid defining the license line.
    }
    elsif ($in_set) {
        my $lic = 'stdenv.lib.licenses';
        if ( @$licenses == 1 ) {
            $license_line = "$lic.$licenses->[0]";
        }
        else {
            $license_line = "with $lic; [ " . join( ' ', @$licenses ) . " ]";
        }
    }
    else {
        if ( @$licenses == 1 ) {
            $license_line = $licenses->[0];
        }
        else {
            $license_line = '[ ' . join( ' ', @$licenses ) . ' ]';
        }
    }

    INFO("license: $cpan_license");
    WARN("License '$cpan_license' is ambiguous, please verify") if $amb;

    return $license_line;
}

my ( $opt, $module_name ) = handle_opts();

Log::Log4perl->easy_init(
    {
        level => $opt->debug ? $DEBUG : $INFO,
        layout => '%m%n'
    }
);

my $cb = CPANPLUS::Backend->new;

my @modules = $cb->search( type => "name", allow => [$module_name] );
die "module $module_name not found\n" if scalar @modules == 0;
die "multiple packages that match module $module_name\n" if scalar @modules > 1;
my $module = $modules[0];

my $pkg_name  = get_pkg_name $module;
my $attr_name = pkg_to_attr $module;

INFO( "attribute name: ", $attr_name );
INFO( "module: ",         $module->module );
INFO( "version: ",        $module->version );
INFO( "package: ", $module->package, " (", $pkg_name, ", ", $attr_name, ")" );
INFO( "path: ",    $module->path );

my $tar_path = $module->fetch();
INFO( "downloaded to: ", $tar_path );
INFO( "sha-256: ",       $module->status->checksum_value );

my $pkg_path = $module->extract();
INFO( "unpacked to: ", $pkg_path );

my $meta = read_meta($pkg_path);

DEBUG( "metadata: ", encode_json( $meta->as_struct ) ) if defined $meta;

my @runtime_deps = sort( uniq( get_deps( $cb, $meta, "runtime" ) ) );
INFO("runtime deps: @runtime_deps");

my @build_deps = sort( uniq(
        get_deps( $cb, $meta, "configure" ),
        get_deps( $cb, $meta, "build" ),
        get_deps( $cb, $meta, "test" )
) );

# Filter out runtime dependencies since those are already handled.
my %in_runtime_deps = map { $_ => 1 } @runtime_deps;
@build_deps = grep { not $in_runtime_deps{$_} } @build_deps;

INFO("build deps: @build_deps");

my $homepage = $meta ? $meta->resources->{homepage} : undef;
INFO("homepage: $homepage") if defined $homepage;

my $description = $meta ? $meta->abstract : undef;
if ( defined $description ) {
    $description = uc( substr( $description, 0, 1 ) )
      . substr( $description, 1 );    # capitalise first letter
    $description =~ s/\.$//;          # remove period at the end
    $description =~ s/\s*$//;
    $description =~ s/^\s*//;
    $description =~ s/\n+/ /;         # Replace new lines by space.
    INFO("description: $description");
}

#print(Data::Dumper::Dumper($meta->licenses) . "\n");
my $license = $meta ? render_license( $meta->licenses ) : undef;

INFO( "RSS feed: https://metacpan.org/feed/distribution/",
    $module->package_name );

my $build_fun = -e "$pkg_path/Build.PL"
  && !-e "$pkg_path/Makefile.PL" ? "buildPerlModule" : "buildPerlPackage";

print STDERR "===\n";

print <<EOF;
  ${\(is_reserved($attr_name) ? "\"$attr_name\"" : $attr_name)} = $build_fun rec {
    name = "$pkg_name";
    src = fetchurl {
      url = "mirror://cpan/${\$module->path}/\${name}.${\$module->package_extension}";
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
print <<EOF if defined $description && $description ne "Unknown";
      description = "$description";
EOF
print <<EOF if defined $license;
      license = $license;
EOF
print <<EOF if $opt->maintainer;
      maintainers = [ maintainers.${\$opt->maintainer} ];
EOF
print <<EOF;
    };
  };
EOF
