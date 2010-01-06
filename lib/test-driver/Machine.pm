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
    my ($class, $args) = @_;

    my $startCommand = $args->{startCommand};
    if (!$startCommand) {
        # !!! merge with qemu-vm.nix.
        $startCommand =
            "qemu-system-x86_64 -m 384 -no-kvm-irqchip " .
            "-net nic,model=virtio -net user \$QEMU_OPTS ";
        $startCommand .= "-cdrom $args->{cdrom} "
            if defined $args->{cdrom};
        #-drive file=$NIX_DISK_IMAGE,if=virtio,boot=on
    }

    my $name = $args->{name};
    if (!$name) {
        $startCommand =~ /run-(.*)-vm$/;
        $name = $1 || "machine";
    }

    my $tmpDir = $ENV{'TMPDIR'} || "/tmp";
    
    my $self = {
        startCommand => $startCommand,
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
        $ENV{QEMU_KERNEL_PARAMS} = "console=tty1 console=ttyS0 panic=1 hostTmpDir=$ENV{TMPDIR}";
        chdir $self->{stateDir} or die;
        exec $self->{startCommand};
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


# Take a screenshot of the X server on :0.0.
sub screenshot {
    my ($self, $filename) = @_;
    my $scrot = $ENV{'scrot'} or die;
    $self->mustSucceed("$scrot /hostfs/$ENV{out}/${filename}.png");
}


# Wait until it is possible to connect to the X server.  Note that
# testing the existence of /tmp/.X11-unix/X0 is insufficient.
sub waitForX {
    my ($self, $regexp) = @_;
    while (1) {
        my ($status, $out) = $self->execute("xwininfo -root > /dev/null 2>&1");
        return if $status == 0;
        sleep 1;
    }
};


sub getWindowNames {
    my ($self) = @_;
    my $res = $self->mustSucceed(
        q{xwininfo -root -tree | sed 's/.*0x[0-9a-f]* \"\([^\"]*\)\".*/\1/; t; d'});
    return split /\n/, $res;
}


sub waitForWindow {
    my ($self, $regexp) = @_;
    while (1) {
        my @names = $self->getWindowNames;
        foreach my $n (@names) {
            return if $n =~ /$regexp/;
        }
        sleep 2;
    }
};


1;
