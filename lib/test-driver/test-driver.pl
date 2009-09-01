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

    # Copy the kernel coverage data for each machine, if the kernel
    # has been compiled with coverage instrumentation.
    foreach my $vm (values %vms) {
        my ($status, $out) = $vm->execute("test -e /proc/gcov");
        next if $status != 0;

        # Figure out where to put the *.gcda files so that the report
        # generator can find the corresponding kernel sources.
        my $kernelDir = $vm->mustSucceed("echo \$(dirname \$(readlink -f /var/run/current-system/kernel))/.build/linux-*");
        chomp $kernelDir;
        my $coverageDir = "/hostfs" . $vm->stateDir() . "/coverage-data/$kernelDir";

        # Copy all the *.gcda files.  The ones under
        # /proc/gcov/module/nix/store are the kernel modules in the
        # initrd to which we have applied nuke-refs in
        # makeModuleClosure.  This confuses the gcov module a bit.
        $vm->execute("for i in \$(cd /proc/gcov && find -name module -prune -o -name '*.gcda'); do echo \$i; mkdir -p $coverageDir/\$(dirname \$i); cp -v /proc/gcov/\$i $coverageDir/\$i; done");

        $vm->execute("for i in \$(cd /proc/gcov/module/nix/store/*/.build/* && find -name module -prune -o -name '*.gcda'); do mkdir -p $coverageDir/\$(dirname \$i); cp /proc/gcov/module/nix/store/*/.build/*/\$i $coverageDir/\$i; done");
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
