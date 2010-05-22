package Machine;

use strict;
use threads;
use Thread::Queue;
use Socket;
use IO::Handle;
use POSIX qw(dup2);
use FileHandle;
use Cwd;


# Stuff our PID in the multicast address/port to prevent collissions
# with other NixOS VM networks.  See
# http://www.iana.org/assignments/multicast-addresses/.
my $mcastPrefix = "232.18";
my $mcastSuffix = ($$ >> 8) . ":" . (64000 + ($$ & 0xff));
print STDERR "using multicast addresses $mcastPrefix.<vlan>.$mcastSuffix\n";
for (my $n = 0; $n < 256; $n++) {
    $ENV{"QEMU_MCAST_ADDR_$n"} = "$mcastPrefix.$n.$mcastSuffix";
}


sub new {
    my ($class, $args) = @_;

    my $startCommand = $args->{startCommand};
    if (!$startCommand) {
        # !!! merge with qemu-vm.nix.
        $startCommand =
            "qemu-system-x86_64 -m 384 -no-kvm-irqchip " .
            "-net nic,model=virtio -net user \$QEMU_OPTS ";
        $startCommand .= "-drive file=" . Cwd::abs_path($args->{hda}) . ",if=virtio,boot=on,werror=report "
            if defined $args->{hda};
        $startCommand .= "-cdrom $args->{cdrom} "
            if defined $args->{cdrom};
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
        monitor => undef,
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

    # Create a socket pair for the serial line input/output of the VM.
    my ($serialP, $serialC);
    socketpair($serialP, $serialC, PF_UNIX, SOCK_STREAM, 0) or die;

    # Create a Unix domain socket to which QEMU's monitor will connect.
    my $monitorPath = $self->{stateDir} . "/monitor";
    unlink $monitorPath;
    my $monitorS;
    socket($monitorS, PF_UNIX, SOCK_STREAM, 0) or die;
    bind($monitorS, sockaddr_un($monitorPath)) or die "cannot bind monitor socket: $!";
    listen($monitorS, 1) or die;

    # Start the VM.
    my $pid = fork();
    die if $pid == -1;

    if ($pid == 0) {
        close $serialP;
        close $monitorS;
        open NUL, "</dev/null" or die;
        dup2(fileno(NUL), fileno(STDIN));
        dup2(fileno($serialC), fileno(STDOUT));
        dup2(fileno($serialC), fileno(STDERR));
        $ENV{TMPDIR} = $self->{stateDir};
        $ENV{QEMU_OPTS} = "-nographic -no-reboot -redir tcp:65535::514 -monitor unix:./monitor";
        $ENV{QEMU_KERNEL_PARAMS} = "hostTmpDir=$ENV{TMPDIR}";
        chdir $self->{stateDir} or die;
        exec $self->{startCommand};
        die;
    }

    # Wait until QEMU connects to the monitor.
    accept($self->{monitor}, $monitorS) or die;
    $self->waitForMonitorPrompt;

    # Process serial line output.
    close $serialC;

    threads->create(\&processSerialOutput, $self, $serialP)->detach;

    sub processSerialOutput {
        my ($self, $serialP) = @_;
        $/ = "\r\n";
        while (<$serialP>) {
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


# Send a command to the monitor and wait for it to finish.  TODO: QEMU
# also has a JSON-based monitor interface now, but it doesn't support
# all commands yet.  We should use it once it does.
sub sendMonitorCommand {
    my ($self, $command) = @_;
    $self->log("sending monitor command: $command");
    syswrite $self->{monitor}, "$command\n";
    return $self->waitForMonitorPrompt;
}


# Wait until the monitor sends "(qemu) ".
sub waitForMonitorPrompt {
    my ($self) = @_;
    my $res = "";
    my $s;
    while (sysread($self->{monitor}, $s, 1024)) {
        $res .= $s;
        last if $res =~ s/\(qemu\) $//;
    }
    return $res;
}


# Call the given code reference repeatedly, with 1 second intervals,
# until it returns 1 or a timeout is reached.
sub retry {
    my ($coderef) = @_;
    my $n;
    for ($n = 0; $n < 900; $n++) {
        return if &$coderef;
        sleep 1;
    }
    die "action timed out after $n seconds";
}


sub connect {
    my ($self) = @_;
    return if $self->{connected};

    $self->start;

    # Wait until the processQemuOutput thread signals that the machine
    # is up.
    retry sub {
        return 1 if $self->{connectedQueue}->dequeue_nb();
    };

    retry sub {
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
        return 1 if $line eq "hello";
    };

    $self->log("connected");
    $self->{connected} = 1;
}


sub waitForShutdown {
    my ($self) = @_;
    return unless $self->{booted};
    
    waitpid $self->{pid}, 0;
    $self->{pid} = 0;
    $self->{booted} = 0;
    $self->{connected} = 0;
}


sub isUp {
    my ($self) = @_;
    return $self->{booted} && $self->{connected};
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


sub succeed {
    my ($self, @commands) = @_;
    my $res;
    foreach my $command (@commands) {
        my ($status, $out) = $self->execute($command);
        if ($status != 0) {
            $self->log("output: $out");
            die "command `$command' did not succeed (exit code $status)";
        }
        $res .= $out;
    }
    return $res;
}


sub mustSucceed {
    succeed @_;
}


sub waitUntilSucceeds {
    my ($self, $command) = @_;
    retry sub {
        my ($status, $out) = $self->execute($command);
        return 1 if $status == 0;
    };
}


sub waitUntilFails {
    my ($self, $command) = @_;
    retry sub {
        my ($status, $out) = $self->execute($command);
        return 1 if $status != 0;
    };
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
    retry sub {
        my ($status, $out) = $self->execute("initctl status $jobName");
        return 1 if $out =~ /start\/running/;
    };
}


# Wait until the specified file exists.
sub waitForFile {
    my ($self, $fileName) = @_;
    retry sub {
        my ($status, $out) = $self->execute("test -e $fileName");
        return 1 if $status == 0;
    }
}


sub stopJob {
    my ($self, $jobName) = @_;
    $self->execute("initctl stop $jobName");
    my ($status, $out) = $self->execute("initctl status $jobName");
    die "failed to stop $jobName" unless $out =~ /stop\/waiting/;
}


# Wait until the machine is listening on the given TCP port.
sub waitForOpenPort {
    my ($self, $port) = @_;
    retry sub {
        my ($status, $out) = $self->execute("nc -z localhost $port");
        return 1 if $status == 0;
    }
}


# Wait until the machine is not listening on the given TCP port.
sub waitForClosedPort {
    my ($self, $port) = @_;
    retry sub {
        my ($status, $out) = $self->execute("nc -z localhost $port");
        return 1 if $status != 0;
    }
}


sub shutdown {
    my ($self) = @_;
    return unless $self->{booted};

    $self->execute("poweroff");

    $self->waitForShutdown;
}


# Make the machine unreachable by shutting down eth1 (the multicast
# interface used to talk to the other VMs).  We keep eth0 up so that
# the test driver can continue to talk to the machine.
sub block {
    my ($self) = @_;
    $self->sendMonitorCommand("set_link virtio-net-pci.1 down");
}


# Make the machine reachable.
sub unblock {
    my ($self) = @_;
    $self->sendMonitorCommand("set_link virtio-net-pci.1 up");
}


# Take a screenshot of the X server on :0.0.
sub screenshot {
    my ($self, $filename) = @_;
    $filename = "$ENV{'out'}/${filename}.png" if $filename =~ /^\w+$/;
    my $tmp = "${filename}.ppm";
    $self->sendMonitorCommand("screendump $tmp");
    system("convert $tmp ${filename}") == 0
        or die "cannot convert screenshot";
    unlink $tmp;
}


# Wait until it is possible to connect to the X server.  Note that
# testing the existence of /tmp/.X11-unix/X0 is insufficient.
sub waitForX {
    my ($self, $regexp) = @_;
    retry sub {
        my ($status, $out) = $self->execute("xwininfo -root > /dev/null 2>&1");
        return 1 if $status == 0;
    }
}


sub getWindowNames {
    my ($self) = @_;
    my $res = $self->mustSucceed(
        q{xwininfo -root -tree | sed 's/.*0x[0-9a-f]* \"\([^\"]*\)\".*/\1/; t; d'});
    return split /\n/, $res;
}


sub waitForWindow {
    my ($self, $regexp) = @_;
    retry sub {
        my @names = $self->getWindowNames;
        foreach my $n (@names) {
            return 1 if $n =~ /$regexp/;
        }
    }
}


sub copyFileFromHost {
    my ($self, $from, $to) = @_;
    my $s = `cat $from` or die;
    $self->mustSucceed("echo '$s' > $to"); # !!! escaping
}


sub sendKeys {
    my ($self, @keys) = @_;
    foreach my $key (@keys) {
        $key = "spc" if $key eq " ";
        $key = "ret" if $key eq "\n";
        $self->sendMonitorCommand("sendkey $key");
    }
}


sub sendChars {
    my ($self, $chars) = @_;
    $self->sendKeys(split //, $chars);
}


1;
