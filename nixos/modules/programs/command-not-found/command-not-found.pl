#! @perl@/bin/perl -w

use strict;
use DBI;
use DBD::SQLite;
use String::ShellQuote;
use Config;

my $program = $ARGV[0];

my $dbPath = "@dbPath@";

if (! -e $dbPath) {
    print STDERR "$program: command not found\n";
    print STDERR "\n";
    print STDERR "command-not-found: Missing package database\n";
    print STDERR "command-not-found is a tool for searching for missing packages.\n";
    print STDERR "No database was found, this likely means the database hasn't been generated yet.\n";
    print STDERR "This tool requires nix-channels to generate the database for the `nixos` channel.\n";
    print STDERR "\n";
    print STDERR "If you are using nix-channels you can run:\n";
    print STDERR "    sudo nix-channels --update\n";
    print STDERR "\n";
    print STDERR "If you are using flakes, see nix-index and nix-index-database.\n";
    print STDERR "\n";
    print STDERR "If you would like to disable this message you can set:\n";
    print STDERR "    programs.command-not-found.enable = false;\n";
    exit 127;
}

my $dbh = DBI->connect("dbi:SQLite:dbname=$dbPath", "", "")
    or die "cannot open database `$dbPath'";
$dbh->{RaiseError} = 0;
$dbh->{PrintError} = 0;

my $system = $ENV{"NIX_SYSTEM"} // $Config{myarchname};

my $res = $dbh->selectall_arrayref(
    "select package from Programs where system = ? and name = ?",
    { Slice => {} }, $system, $program);

my $len = !defined $res ? 0 : scalar @$res;

if ($len == 0) {
    print STDERR "$program: command not found\n";
} elsif ($len == 1) {
    my $package = @$res[0]->{package};
    if ($ENV{"NIX_AUTO_RUN"} // "") {
        if ($ENV{"NIX_AUTO_RUN_INTERACTIVE"} // "") {
            while (1) {
                print STDERR "'$program' from package '$package' will be run, confirm? [yn]: ";
                chomp(my $comfirm = <STDIN>);
                if (lc $comfirm eq "n") {
                    exit 0;
                } elsif (lc $comfirm eq "y") {
                    last;
                }
            }
        }
        exec("nix-shell", "-p", $package, "--run", shell_quote("exec", @ARGV));
    } else {
        print STDERR <<EOF;
The program '$program' is not in your PATH. You can make it available in an
ephemeral shell by typing:
  nix-shell -p $package
EOF
    }
} else {
    if ($ENV{"NIX_AUTO_RUN"} // "") {
        print STDERR "Select a package that provides '$program':\n";
        for my $i (0 .. $len - 1) {
            print STDERR "  [", $i + 1, "]: @$res[$i]->{package}\n";
        }
        my $choice = 0;
        while (1) { # exec will break this loop
            no warnings "numeric";
            print STDERR "Your choice [1-${len}]: ";
            # 0 can be invalid user input like non-number string
            # so we start from 1
            $choice = <STDIN> + 0;
            if (1 <= $choice && $choice <= $len) {
                exec("nix-shell", "-p", @$res[$choice - 1]->{package},
                    "--run", shell_quote("exec", @ARGV));
            }
        }
    } else {
        print STDERR <<EOF;
The program '$program' is not in your PATH. It is provided by several packages.
You can make it available in an ephemeral shell by typing one of the following:
EOF
        print STDERR "  nix-shell -p $_->{package}\n" foreach @$res;
    }
}

exit 127;
