use strict;
use Machine;

$SIG{PIPE} = 'IGNORE'; # because Unix domain sockets may die unexpectedly

my %vms;
my $context = "";


foreach my $vmScript (@ARGV) {
    my $vm = Machine->new($vmScript);
    $vms{$vm->name} = $vm;
    $context .= "my \$" . $vm->name . " = \$vms{'" . $vm->name . "'}; ";
}


sub startAll {
    $_->start foreach values %vms;
}


sub runTests {
    eval "$context $ENV{tests}";
    die $@ if $@;
}


END {
    foreach my $vm (values %vms) {
        if ($vm->{pid}) {
            print STDERR "killing ", $vm->{name}, " (pid ", $vm->{pid}, ")\n";
            kill 9, $vm->{pid};
        }
    }
}


runTests;


print STDERR "DONE\n";
