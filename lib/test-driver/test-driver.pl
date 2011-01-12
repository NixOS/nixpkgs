#! /somewhere/perl -w

use strict;
use Machine;
use Term::ReadLine;
use IO::File;
use Logger;
use Cwd;

$SIG{PIPE} = 'IGNORE'; # because Unix domain sockets may die unexpectedly

STDERR->autoflush(1);

my $log = new Logger;


# Start vde_switch for each network required by the test.
my %vlans;
foreach my $vlan (split / /, $ENV{VLANS} || "") {
    next if defined $vlans{$vlan};
    $log->log("starting VDE switch for network $vlan");
    my $socket = Cwd::abs_path "./vde$vlan.ctl";
    system("vde_switch -d -s $socket") == 0
        or die "cannot start vde_switch";
    $ENV{"QEMU_VDE_SOCKET_$vlan"} = $socket;
    $vlans{$vlan} = 1;
}


my %vms;
my $context = "";

sub createMachine {
    my ($args) = @_;
    my $vm = Machine->new({%{$args}, log => $log});
    $vms{$vm->name} = $vm;
    return $vm;
}

foreach my $vmScript (@ARGV) {
    my $vm = createMachine({startCommand => $vmScript});
    $context .= "my \$" . $vm->name . " = \$vms{'" . $vm->name . "'}; ";
}


sub startAll {
    $log->nest("starting all VMs", sub {
        $_->start foreach values %vms;
    });
}


# In interactive tests, this allows the non-interactive test script to
# be executed conveniently.
sub testScript {
    eval "$context $ENV{testScript};\n";
    warn $@ if $@;
}


my $nrTests = 0;
my $nrSucceeded = 0;


sub subtest {
    my ($name, $coderef) = @_;
    $log->nest("subtest: $name", sub {
        $nrTests++;
        eval { &$coderef };
        if ($@) {
            $log->log("error: $@", { error => 1 });
        } else {
            $nrSucceeded++;
        }
    });
}


sub runTests {
    if (defined $ENV{tests}) {
        $log->nest("running the VM test script", sub {
            eval "$context $ENV{tests}";
            if ($@) {
                $log->log("error: $@", { error => 1 });
                die $@;
            }
        }, { expanded => 1 });
    } else {
        my $term = Term::ReadLine->new('nixos-vm-test');
        $term->ReadHistory;
        while (defined ($_ = $term->readline("> "))) {
            eval "$context $_\n";
            warn $@ if $@;
        }
        $term->WriteHistory;
    }

    # Copy the kernel coverage data for each machine, if the kernel
    # has been compiled with coverage instrumentation.
    $log->nest("collecting coverage data", sub {
        foreach my $vm (values %vms) {
            my $gcovDir = "/sys/kernel/debug/gcov";

            next unless $vm->isUp();

            my ($status, $out) = $vm->execute("test -e $gcovDir");
            next if $status != 0;

            # Figure out where to put the *.gcda files so that the
            # report generator can find the corresponding kernel
            # sources.
            my $kernelDir = $vm->mustSucceed("echo \$(dirname \$(readlink -f /var/run/current-system/kernel))/.build/linux-*");
            chomp $kernelDir;
            my $coverageDir = "/hostfs" . $vm->stateDir() . "/coverage-data/$kernelDir";

            # Copy all the *.gcda files.
            $vm->execute("for d in $gcovDir/nix/store/*/.build/linux-*; do for i in \$(cd \$d && find -name '*.gcda'); do echo \$i; mkdir -p $coverageDir/\$(dirname \$i); cp -v \$d/\$i $coverageDir/\$i; done; done");
        }
    });

    if ($nrTests != 0) {
        $log->log("$nrSucceeded out of $nrTests tests succeeded",
            ($nrSucceeded < $nrTests ? { error => 1 } : { }));
    }
}


# Create an empty qcow2 virtual disk with the given name and size (in
# MiB).
sub createDisk {
    my ($name, $size) = @_;
    system("qemu-img create -f qcow2 $name ${size}M") == 0
        or die "cannot create image of size $size";
}


END {
    $log->nest("cleaning up", sub {
        foreach my $vm (values %vms) {
            if ($vm->{pid}) {
                $log->log("killing " . $vm->{name} . " (pid " . $vm->{pid} . ")");
                kill 9, $vm->{pid};
            }
        }
    });
    $log->close();
}


runTests;

exit ($nrSucceeded < $nrTests ? 1 : 0);
