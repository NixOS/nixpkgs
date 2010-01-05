use strict;
use Machine;

$SIG{PIPE} = 'IGNORE'; # because Unix domain sockets may die unexpectedly

STDERR->autoflush(1);

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
    if (defined $ENV{tests}) {
        eval "$context $ENV{tests}";
        die $@ if $@;
    } else {
        while (<STDIN>) {
            eval "$context $_\n";
            warn $@ if $@;
        }
    }

    # Copy the kernel coverage data for each machine, if the kernel
    # has been compiled with coverage instrumentation.
    foreach my $vm (values %vms) {
        my $gcovDir = "/sys/kernel/debug/gcov";

        my ($status, $out) = $vm->execute("test -e $gcovDir");
        next if $status != 0;

        # Figure out where to put the *.gcda files so that the report
        # generator can find the corresponding kernel sources.
        my $kernelDir = $vm->mustSucceed("echo \$(dirname \$(readlink -f /var/run/current-system/kernel))/.build/linux-*");
        chomp $kernelDir;
        my $coverageDir = "/hostfs" . $vm->stateDir() . "/coverage-data/$kernelDir";

        # Copy all the *.gcda files.
        $vm->execute("for d in $gcovDir/nix/store/*/.build/linux-*; do for i in \$(cd \$d && find -name '*.gcda'); do echo \$i; mkdir -p $coverageDir/\$(dirname \$i); cp -v \$d/\$i $coverageDir/\$i; done; done");
    }
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
