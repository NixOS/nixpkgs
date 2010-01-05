package Machine;

use strict;
use threads;
use Thread::Queue;
use Socket;
use IO::Handle;
use POSIX qw(dup2);
use FileHandle;


# Stuff our PID in the multicast address/port to prevent collissions
# with other NixOS VM networks.
my $mcastAddr = "232.18.1." . ($$ >> 8) . ":" . (64000 + ($$ & 0xff));
print STDERR "using multicast address $mcastAddr\n";


sub new {
    my ($class, $vmScript) = @_;

    $vmScript =~ /run-(.*)-vm$/ or die;
    my $name = $1;

    my $tmpDir = $ENV{'TMPDIR'} || "/tmp";
    
    my $self = {
        script => $vmScript,
        name => $name,
        booted => 0,
        pid => 0,
        connected => 0,
        connectedQueue => Thread::Queue->new(),
        socket => undef,
        stateDir => "$tmpDir/$name",
    };

    mkdir $self->{stateDir}, 0700;

    bless $self, $class;
    return $self;
}


sub log {
    my ($self, $msg) = @_;
    chomp $msg;
    print STDERR $self->{name}, ": $msg\n";
}


sub name {
    my ($self) = @_;
    return $self->{name};
}


sub stateDir {
    my ($self) = @_;
    return $self->{stateDir};
}


sub start {
    my ($self) = @_;
    return if $self->{booted};

    $self->log("starting vm");

    my ($read, $write) = FileHandle::pipe;

    my $pid = fork();
    die if $pid == -1;

    if ($pid == 0) {
        close $read;
        dup2(fileno($write), fileno(STDOUT));
        dup2(fileno($write), fileno(STDERR));
        open NUL, "</dev/null" or die;
        dup2(fileno(NUL), fileno(STDIN));
        $ENV{TMPDIR} = $self->{stateDir};
        $ENV{QEMU_OPTS} = "-nographic -no-reboot -redir tcp:65535::514 -net nic,vlan=1 -net socket,vlan=1,mcast=$mcastAddr";
        $ENV{QEMU_KERNEL_PARAMS} = "console=ttyS0 panic=1 hostTmpDir=$ENV{TMPDIR}";
        chdir $self->{stateDir} or die;
        exec $self->{script};
        die;
    }

    close $write;

    threads->create(\&processQemuOutput, $self, $read)->detach;

    sub processQemuOutput {
        my ($self, $read) = @_;
        $/ = "\r\n";
        while (<$read>) {
            chomp;
            print STDERR $self->name, "# $_\n";
            $self->{connectedQueue}->enqueue(1) if $_ eq "===UP===";
        }
        # If the child dies, wake up connect().
        $self->{connectedQueue}->enqueue(1);
    }

    $self->log("vm running as pid $pid");
    $self->{pid} = $pid;
    $self->{booted} = 1;
}


sub connect {
    my ($self) = @_;
    return if $self->{connected};

    $self->start;

    # Wait until the processQemuOutput thread signals that the machine
    # is up.
    $self->{connectedQueue}->dequeue();

    while (1) {
        $self->log("trying to connect");
        my $socket = new IO::Handle;
        $self->{socket} = $socket;
        socket($socket, PF_UNIX, SOCK_STREAM, 0) or die;
        connect($socket, sockaddr_un($self->{stateDir} . "/65535.socket")) or die;
        $socket->autoflush(1);
        print $socket "echo hello\n" or next;
        flush $socket;
        my $line = readline($socket);
        chomp $line;
        last if $line eq "hello";
        sleep 1;
    }    

    $self->log("connected");
    $self->{connected} = 1;
    
    print { $self->{socket} } "PATH=/var/run/current-system/sw/bin:/var/run/current-system/sw/sbin:\$PATH\n";
    print { $self->{socket} } "export GCOV_PREFIX=/tmp/coverage-data\n";
    print { $self->{socket} } "cd /tmp\n";
    # !!! Should make sure the commands above don't produce output, otherwise we're out of sync.
}


sub waitForShutdown {
    my ($self) = @_;
    return unless $self->{booted};
    
    waitpid $self->{pid}, 0;
    $self->{pid} = 0;
    $self->{booted} = 0;
}


sub execute {
    my ($self, $command) = @_;
    
    $self->connect;

    $self->log("running command: $command");

    print { $self->{socket} } ("( $command ); echo '|!=EOF' \$?\n");

    my $out = "";

    while (1) {
        my $line = readline($self->{socket}) or die "connection to VM lost unexpectedly";
        #$self->log("got line: $line");
        if ($line =~ /^(.*)\|\!\=EOF\s+(\d+)$/) {
            $out .= $1;
            $self->log("exit status $2");
            return ($2, $out);
        }
        $out .= $line;
    }
}


sub mustSucceed {
    my ($self, $command) = @_;
    my ($status, $out) = $self->execute($command);
    if ($status != 0) {
        $self->log("output: $out");
        die "command `$command' did not succeed (exit code $status)";
    }
    return $out;
}


sub mustFail {
    my ($self, $command) = @_;
    my ($status, $out) = $self->execute($command);
    die "command `$command' unexpectedly succeeded"
        if $status == 0;
}


# Wait for an Upstart job to reach the "running" state.
sub waitForJob {
    my ($self, $jobName) = @_;
    while (1) {
        my ($status, $out) = $self->execute("initctl status $jobName");
        return if $out =~ /start\/running/;
        sleep 1;
        # !!! need a timeout
    }
}


# Wait until the specified file exists.
sub waitForFile {
    my ($self, $fileName) = @_;
    while (1) {
        my ($status, $out) = $self->execute("test -e $fileName");
        return if $status == 0;
        sleep 1;
        # !!! need a timeout
    }
}


sub stopJob {
    my ($self, $jobName) = @_;
    $self->execute("initctl stop $jobName");
    while (1) {
        my ($status, $out) = $self->execute("initctl status $jobName");
        return if $out =~ /stop\/waiting/;
        sleep 1;
        # !!! need a timeout
    }
}


# Wait until the machine is listening on the given TCP port.
sub waitForOpenPort {
    my ($self, $port) = @_;
    while (1) {
        my ($status, $out) = $self->execute("nc -z localhost $port");
        return if $status == 0;
        sleep 1;
    }
}


# Wait until the machine is not listening on the given TCP port.
sub waitForClosedPort {
    my ($self, $port) = @_;
    while (1) {
        my ($status, $out) = $self->execute("nc -z localhost $port");
        return if $status != 0;
        sleep 1;
    }
}


sub shutdown {
    my ($self) = @_;
    return unless $self->{booted};

    $self->execute("poweroff -f &");

    $self->waitForShutdown;
}


# Make the machine unreachable by shutting down eth1 (the multicast
# interface used to talk to the other VMs).  We keep eth0 up so that
# the test driver can continue to talk to the machine.
sub block {
    my ($self) = @_;
    $self->mustSucceed("ifconfig eth1 down");
}


# Make the machine reachable.
sub unblock {
    my ($self) = @_;
    $self->mustSucceed("ifconfig eth1 up");
}


1;
