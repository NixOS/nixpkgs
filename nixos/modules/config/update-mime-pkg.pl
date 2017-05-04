use strict;
use File::Path qw(make_path);
use File::Slurp;
use JSON;

# NOTE: originally started as something invoked as part
# of activation, similar to the user-groups script.
#
# now that it is is a package, I guess I can port this away from
# perl?

my $out = $ARGV[1];

# Read in the declared mime types
my $spec = decode_json(read_file($ARGV[0]));

my $outfile = "$out/share/mime/packages/nix-decl-types.xml";

my %declOut;
foreach my $t (@{$spec->{types}}) {
	my $name = $t->{name};

	my $alias = $t->{alias} eq "" ? "" : "<alias type=\"$t->{alias}\"/>";

	my $commentPairs = $t->{comment};
	my $comments = "";

	$comments = join("\n", map {
		my $l = $_ eq "" ? "" : " xml:lang=\"$_\"";
		"<comment$l>$commentPairs->{$_}</comment>";
	} keys %$commentPairs);

	my @globList = @{$t->{globs}};
	my $globs = join("\n", map { "<glob pattern=\"$_\"/>" } @globList);

	my $sc = $t->{"sub-class-of"};
	my $subClassOf = $sc eq "" ? "" : "<sub-class-of type=\"$sc\"/>";

	my $magic = ""; ##TODO: magic hasn't been done yet

	##TODO: icons
	##TODO: xml prettify

$declOut{$name} = <<END;
<mime-type type="$name">
$comments
$globs
$subClassOf
$magic
$alias
</mime-type>
END

}

my $body = join("\n", sort(values %declOut));

my $fullBody = <<END;
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
	$body
</mime-info>
END

write_file($outfile, { binmode => ':utf8' }, $fullBody)

