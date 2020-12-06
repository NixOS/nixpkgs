#! @perl@/bin/perl -w @perlFlags@

use strict;
use DBI;
use DBD::SQLite;
use String::ShellQuote;
use Config;

my $program = $ARGV[0];

my $dbPath = "@dbPath@";

my $dbh = DBI->connect("dbi:SQLite:dbname=$dbPath", "", "")
    or die "cannot open database `$dbPath'";
$dbh->{RaiseError} = 0;
$dbh->{PrintError} = 0;

my $system = $ENV{"NIX_SYSTEM"} // $Config{myarchname};

my $res = $dbh->selectall_arrayref(
    "select package from Programs where system = ? and name = ?",
    { Slice => {} }, $system, $program);

if (!defined $res || scalar @$res == 0) {
    print STDERR "$program: command not found\n";
} elsif (scalar @$res == 1) {
    my $package = @$res[0]->{package};
    if ($ENV{"NIX_AUTO_INSTALL"} // "") {
        print STDERR <<EOF;
The program ‘$program’ is currently not installed. It is provided by
the package ‘$package’, which I will now install for you.
EOF
        ;
        exit 126 if system("nix-env", "-iA", "nixos.$package") == 0;
    } elsif ($ENV{"NIX_AUTO_RUN"} // "") {
        exec("nix-shell", "-p", $package, "--run", shell_quote("exec", @ARGV));
    } else {
        print STDERR <<EOF;
The program ‘$program’ is currently not installed. You can install it by typing:
  nix-env -iA nixos.$package
EOF
    }
} else {
    print STDERR <<EOF;
The program ‘$program’ is currently not installed. It is provided by
several packages. You can install it by typing one of the following:
EOF
    print STDERR "  nix-env -iA nixos.$_->{package}\n" foreach @$res;
}

exit 127;
