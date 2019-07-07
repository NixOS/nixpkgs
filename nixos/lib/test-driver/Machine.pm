package Machine;

use strict;
use threads;
use Socket;
use IO::Handle;
use POSIX qw(dup2);
use FileHandle;
use Cwd;
use File::Basename;
use File::Path qw(make_path);
use File::Slurp;
use Time::HiRes qw(clock_gettime CLOCK_MONOTONIC);


my $showGraphics = defined $ENV{'DISPLAY'};

my $sharedDir;


sub new {
    my ($class, $args) = @_;

    my $startCommand = $args->{startCommand};

    my $name = $args->{name};
    if (!$name) {
        $startCommand =~ /run-(.*)-vm$/ if defined $startCommand;
        $name = $1 || "machine";
    }

    if (!$startCommand) {
        # !!! merge with qemu-vm.nix.
        $startCommand =
            "qemu-kvm -m 384 " .
            "-net nic,model=virtio \$QEMU_OPTS ";

        if (defined $args->{hda}) {
            if ($args->{hdaInterface} eq "scsi") {
                $startCommand .= "-drive id=hda,file="
                               . Cwd::abs_path($args->{hda})
                               . ",werror=report,if=none "
                               . "-device scsi-hd,drive=hda ";
            } else {
                $startCommand .= "-drive file=" . Cwd::abs_path($args->{hda})
                               . ",if=" . $args->{hdaInterface}
                               . ",werror=report ";
            }
        }

        $startCommand .= "-cdrom $args->{cdrom} "
            if defined $args->{cdrom};
        $startCommand .= "-device piix3-usb-uhci -drive id=usbdisk,file=$args->{usb},if=none,readonly -device usb-storage,drive=usbdisk "
            if defined $args->{usb};
        $startCommand .= "-bios $args->{bios} "
            if defined $args->{bios};
        $startCommand .= $args->{qemuFlags} || "";
    }

    my $tmpDir = $ENV{'TMPDIR'} || "/tmp";
    unless (defined $sharedDir) {
        $sharedDir = $tmpDir . "/xchg-shared";
        make_path($sharedDir, { mode => 0700, owner => $< });
    }

    my $allowReboot = 0;
    $allowReboot = $args->{allowReboot} if defined $args->{allowReboot};

    my $self = {
        startCommand => $startCommand,
        name => $name,
        allowReboot => $allowReboot,
        booted => 0,
        pid => 0,
        connected => 0,
        socket => undef,
        stateDir => "$tmpDir/vm-state-$name",
        monitor => undef,
        log => $args->{log},
        redirectSerial => $args->{redirectSerial} // 1,
    };

    mkdir $self->{stateDir}, 0700;

    bless $self, $class;
    return $self;
}


sub log {
    my ($self, $msg) = @_;
    $self->{log}->log($msg, { machine => $self->{name} });
}


sub nest {
    my ($self, $msg, $coderef, $attrs) = @_;
    $self->{log}->nest($msg, $coderef, { %{$attrs || {}}, machine => $self->{name} });
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

    # Create a Unix domain socket to which the root shell in the guest will connect.
    my $shellPath = $self->{stateDir} . "/shell";
    unlink $shellPath;
    my $shellS;
    socket($shellS, PF_UNIX, SOCK_STREAM, 0) or die;
    bind($shellS, sockaddr_un($shellPath)) or die "cannot bind shell socket: $!";
    listen($shellS, 1) or die;

    # Start the VM.
    my $pid = fork();
    die if $pid == -1;

    if ($pid == 0) {
        close $serialP;
        close $monitorS;
        close $shellS;
        if ($self->{redirectSerial}) {
            open NUL, "</dev/null" or die;
            dup2(fileno(NUL), fileno(STDIN));
            dup2(fileno($serialC), fileno(STDOUT));
            dup2(fileno($serialC), fileno(STDERR));
        }
        $ENV{TMPDIR} = $self->{stateDir};
        $ENV{SHARED_DIR} = $sharedDir;
        $ENV{USE_TMPDIR} = 1;
        $ENV{QEMU_OPTS} =
            ($self->{allowReboot} ? "" : "-no-reboot ") .
            "-monitor unix:./monitor -chardev socket,id=shell,path=./shell " .
            "-device virtio-serial -device virtconsole,chardev=shell " .
            "-device virtio-rng-pci " .
            ($showGraphics ? "-serial stdio" : "-nographic") . " " . ($ENV{QEMU_OPTS} || "");
        chdir $self->{stateDir} or die;
        exec $self->{startCommand};
        die "running VM script: $!";
    }

    # Process serial line output.
    close $serialC;

    threads->create(\&processSerialOutput, $self, $serialP)->detach;

    sub processSerialOutput {
        my ($self, $serialP) = @_;
        while (<$serialP>) {
            chomp;
            s/\r$//;
            print STDERR $self->{name}, "# $_\n";
            $self->{log}->{logQueue}->enqueue({msg => $_, machine => $self->{name}}); # !!!
        }
    }

    eval {
        local $SIG{CHLD} = sub { die "QEMU died prematurely\n"; };

        # Wait until QEMU connects to the monitor.
        accept($self->{monitor}, $monitorS) or die;

        # Wait until QEMU connects to the root shell socket.  QEMU
        # does so immediately; this doesn't mean that the root shell
        # has connected yet inside the guest.
        accept($self->{socket}, $shellS) or die;
        $self->{socket}->autoflush(1);
    };
    die "$@" if $@;

    $self->waitForMonitorPrompt;

    $self->log("QEMU running (pid $pid)");

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
    for ($n = 899; $n >=0; $n--) {
        return if &$coderef($n);
        sleep 1;
    }
    die "action timed out after $n seconds";
}


sub connect {
    my ($self) = @_;
    return if $self->{connected};

    $self->nest("waiting for the VM to finish booting", sub {

        $self->start;

        my $now = clock_gettime(CLOCK_MONOTONIC);
        local $SIG{ALRM} = sub { die "timed out waiting for the VM to connect\n"; };
        alarm 600;
        readline $self->{socket} or die "the VM quit before connecting\n";
        alarm 0;

        $self->log("connected to guest root shell");
        # We're interested in tracking how close we are to `alarm`.
        $self->log(sprintf("(connecting took %.2f seconds)", clock_gettime(CLOCK_MONOTONIC) - $now));
        $self->{connected} = 1;

    });
}


sub waitForShutdown {
    my ($self) = @_;
    return unless $self->{booted};

    $self->nest("waiting for the VM to power off", sub {
        waitpid $self->{pid}, 0;
        $self->{pid} = 0;
        $self->{booted} = 0;
        $self->{connected} = 0;
    });
}


sub isUp {
    my ($self) = @_;
    return $self->{booted} && $self->{connected};
}


sub execute_ {
    my ($self, $command) = @_;

    $self->connect;

    print { $self->{socket} } ("( $command ); echo '|!=EOF' \$?\n");

    my $out = "";

    while (1) {
        my $line = readline($self->{socket});
        die "connection to VM lost unexpectedly" unless defined $line;
        #$self->log("got line: $line");
        if ($line =~ /^(.*)\|\!\=EOF\s+(\d+)$/) {
            $out .= $1;
            $self->log("exit status $2");
            return ($2, $out);
        }
        $out .= $line;
    }
}


sub execute {
    my ($self, $command) = @_;
    my @res;
    $self->nest("running command: $command", sub {
        @res = $self->execute_($command);
    });
    return @res;
}


sub succeed {
    my ($self, @commands) = @_;

    my $res;
    foreach my $command (@commands) {
        $self->nest("must succeed: $command", sub {
            my ($status, $out) = $self->execute_($command);
            if ($status != 0) {
                $self->log("output: $out");
                die "command `$command' did not succeed (exit code $status)\n";
            }
            $res .= $out;
        });
    }

    return $res;
}


sub mustSucceed {
    succeed @_;
}


sub waitUntilSucceeds {
    my ($self, $command) = @_;
    $self->nest("waiting for success: $command", sub {
        retry sub {
            my ($status, $out) = $self->execute($command);
            return 1 if $status == 0;
        };
    });
}


sub waitUntilFails {
    my ($self, $command) = @_;
    $self->nest("waiting for failure: $command", sub {
        retry sub {
            my ($status, $out) = $self->execute($command);
            return 1 if $status != 0;
        };
    });
}


sub fail {
    my ($self, $command) = @_;
    $self->nest("must fail: $command", sub {
        my ($status, $out) = $self->execute_($command);
        die "command `$command' unexpectedly succeeded"
            if $status == 0;
    });
}


sub mustFail {
    fail @_;
}


sub getUnitInfo {
    my ($self, $unit, $user) = @_;
    my ($status, $lines) = $self->systemctl("--no-pager show \"$unit\"", $user);
    return undef if $status != 0;
    my $info = {};
    foreach my $line (split '\n', $lines) {
        $line =~ /^([^=]+)=(.*)$/ or next;
        $info->{$1} = $2;
    }
    return $info;
}

sub systemctl {
    my ($self, $q, $user) = @_;
    if ($user) {
        $q =~ s/'/\\'/g;
        return $self->execute("su -l $user -c \$'XDG_RUNTIME_DIR=/run/user/`id -u` systemctl --user $q'");
    }

    return $self->execute("systemctl $q");
}

# Fail if the given systemd unit is not in the "active" state.
sub requireActiveUnit {
    my ($self, $unit) = @_;
    $self->nest("checking if unit ‘$unit’ has reached state 'active'", sub {
        my $info = $self->getUnitInfo($unit);
        my $state = $info->{ActiveState};
        if ($state ne "active") {
            die "Expected unit ‘$unit’ to to be in state 'active' but it is in state ‘$state’\n";
        };
    });
}

# Wait for a systemd unit to reach the "active" state.
sub waitForUnit {
    my ($self, $unit, $user) = @_;
    $self->nest("waiting for unit ‘$unit’", sub {
        retry sub {
            my $info = $self->getUnitInfo($unit, $user);
            my $state = $info->{ActiveState};
            die "unit ‘$unit’ reached state ‘$state’\n" if $state eq "failed";
            if ($state eq "inactive") {
                # If there are no pending jobs, then assume this unit
                # will never reach active state.
                my ($status, $jobs) = $self->systemctl("list-jobs --full 2>&1", $user);
                if ($jobs =~ /No jobs/) {  # FIXME: fragile
                    # Handle the case where the unit may have started
                    # between the previous getUnitInfo() and
                    # list-jobs.
                    my $info2 = $self->getUnitInfo($unit);
                    die "unit ‘$unit’ is inactive and there are no pending jobs\n"
                        if $info2->{ActiveState} eq $state;
                }
            }
            return 1 if $state eq "active";
        };
    });
}


sub waitForJob {
    my ($self, $jobName) = @_;
    return $self->waitForUnit($jobName);
}


# Wait until the specified file exists.
sub waitForFile {
    my ($self, $fileName) = @_;
    $self->nest("waiting for file ‘$fileName’", sub {
        retry sub {
            my ($status, $out) = $self->execute("test -e $fileName");
            return 1 if $status == 0;
        }
    });
}

sub startJob {
    my ($self, $jobName, $user) = @_;
    $self->systemctl("start $jobName", $user);
    # FIXME: check result
}

sub stopJob {
    my ($self, $jobName, $user) = @_;
    $self->systemctl("stop $jobName", $user);
}


# Wait until the machine is listening on the given TCP port.
sub waitForOpenPort {
    my ($self, $port) = @_;
    $self->nest("waiting for TCP port $port", sub {
        retry sub {
            my ($status, $out) = $self->execute("nc -z localhost $port");
            return 1 if $status == 0;
        }
    });
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

    print { $self->{socket} } ("poweroff\n");

    $self->waitForShutdown;
}


sub crash {
    my ($self) = @_;
    return unless $self->{booted};

    $self->log("forced crash");

    $self->sendMonitorCommand("quit");

    $self->waitForShutdown;
}


# Make the machine unreachable by shutting down eth1 (the multicast
# interface used to talk to the other VMs).  We keep eth0 up so that
# the test driver can continue to talk to the machine.
sub block {
    my ($self) = @_;
    $self->sendMonitorCommand("set_link virtio-net-pci.1 off");
}


# Make the machine reachable.
sub unblock {
    my ($self) = @_;
    $self->sendMonitorCommand("set_link virtio-net-pci.1 on");
}


# Take a screenshot of the X server on :0.0.
sub screenshot {
    my ($self, $filename) = @_;
    my $dir = $ENV{'out'} || Cwd::abs_path(".");
    $filename = "$dir/${filename}.png" if $filename =~ /^\w+$/;
    my $tmp = "${filename}.ppm";
    my $name = basename($filename);
    $self->nest("making screenshot ‘$name’", sub {
        $self->sendMonitorCommand("screendump $tmp");
        system("pnmtopng $tmp > ${filename}") == 0
            or die "cannot convert screenshot";
        unlink $tmp;
    }, { image => $name } );
}

# Get the text of TTY<n>
sub getTTYText {
    my ($self, $tty) = @_;

    my ($status, $out) = $self->execute("fold -w\$(stty -F /dev/tty${tty} size | awk '{print \$2}') /dev/vcs${tty}");
    return $out;
}

# Wait until TTY<n>'s text matches a particular regular expression
sub waitUntilTTYMatches {
    my ($self, $tty, $regexp) = @_;

    $self->nest("waiting for $regexp to appear on tty $tty", sub {
        retry sub {
            my ($retries_remaining) = @_;
            if ($retries_remaining == 0) {
                $self->log("Last chance to match /$regexp/ on TTY$tty, which currently contains:");
                $self->log($self->getTTYText($tty));
            }

            return 1 if $self->getTTYText($tty) =~ /$regexp/;
        }
    });
}

# Debugging: Dump the contents of the TTY<n>
sub dumpTTYContents {
    my ($self, $tty) = @_;

    $self->execute("fold -w 80 /dev/vcs${tty} | systemd-cat");
}

# Take a screenshot and return the result as text using optical character
# recognition.
sub getScreenText {
    my ($self) = @_;

    system("command -v tesseract &> /dev/null") == 0
        or die "getScreenText used but enableOCR is false";

    my $text;
    $self->nest("performing optical character recognition", sub {
        my $tmpbase = Cwd::abs_path(".")."/ocr";
        my $tmpin = $tmpbase."in.ppm";

        $self->sendMonitorCommand("screendump $tmpin");

        my $magickArgs = "-filter Catrom -density 72 -resample 300 "
                       . "-contrast -normalize -despeckle -type grayscale "
                       . "-sharpen 1 -posterize 3 -negate -gamma 100 "
                       . "-blur 1x65535";
        my $tessArgs = "-c debug_file=/dev/null --psm 11 --oem 2";

        $text = `convert $magickArgs $tmpin tiff:- | tesseract - - $tessArgs`;
        my $status = $? >> 8;
        unlink $tmpin;

        die "OCR failed with exit code $status" if $status != 0;
    });
    return $text;
}


# Wait until a specific regexp matches the textual contents of the screen.
sub waitForText {
    my ($self, $regexp) = @_;
    $self->nest("waiting for $regexp to appear on the screen", sub {
        retry sub {
            my ($retries_remaining) = @_;
            if ($retries_remaining == 0) {
                $self->log("Last chance to match /$regexp/ on the screen, which currently contains:");
                $self->log($self->getScreenText);
            }

            return 1 if $self->getScreenText =~ /$regexp/;
        }
    });
}


# Wait until it is possible to connect to the X server.  Note that
# testing the existence of /tmp/.X11-unix/X0 is insufficient.
sub waitForX {
    my ($self, $regexp) = @_;
    $self->nest("waiting for the X11 server", sub {
        retry sub {
            my ($status, $out) = $self->execute("journalctl -b SYSLOG_IDENTIFIER=systemd | grep 'Reached target Current graphical'");
            return 0 if $status != 0;
            ($status, $out) = $self->execute("[ -e /tmp/.X11-unix/X0 ]");
            return 1 if $status == 0;
        }
    });
}


sub getWindowNames {
    my ($self) = @_;
    my $res = $self->mustSucceed(
        q{xwininfo -root -tree | sed 's/.*0x[0-9a-f]* \"\([^\"]*\)\".*/\1/; t; d'});
    return split /\n/, $res;
}


sub waitForWindow {
    my ($self, $regexp) = @_;
    $self->nest("waiting for a window to appear", sub {
        retry sub {
            my @names = $self->getWindowNames;

            my ($retries_remaining) = @_;
            if ($retries_remaining == 0) {
                $self->log("Last chance to match /$regexp/ on the the window list, which currently contains:");
                $self->log(join(", ", @names));
            }

            foreach my $n (@names) {
                return 1 if $n =~ /$regexp/;
            }
        }
    });
}


sub copyFileFromHost {
    my ($self, $from, $to) = @_;
    my $s = `cat $from` or die;
    $s =~ s/'/'\\''/g;
    $self->mustSucceed("echo '$s' > $to");
}


my %charToKey = (
    'A' => "shift-a", 'N' => "shift-n",  '-' => "0x0C", '_' => "shift-0x0C", '!' => "shift-0x02",
    'B' => "shift-b", 'O' => "shift-o",  '=' => "0x0D", '+' => "shift-0x0D", '@' => "shift-0x03",
    'C' => "shift-c", 'P' => "shift-p",  '[' => "0x1A", '{' => "shift-0x1A", '#' => "shift-0x04",
    'D' => "shift-d", 'Q' => "shift-q",  ']' => "0x1B", '}' => "shift-0x1B", '$' => "shift-0x05",
    'E' => "shift-e", 'R' => "shift-r",  ';' => "0x27", ':' => "shift-0x27", '%' => "shift-0x06",
    'F' => "shift-f", 'S' => "shift-s", '\'' => "0x28", '"' => "shift-0x28", '^' => "shift-0x07",
    'G' => "shift-g", 'T' => "shift-t",  '`' => "0x29", '~' => "shift-0x29", '&' => "shift-0x08",
    'H' => "shift-h", 'U' => "shift-u", '\\' => "0x2B", '|' => "shift-0x2B", '*' => "shift-0x09",
    'I' => "shift-i", 'V' => "shift-v",  ',' => "0x33", '<' => "shift-0x33", '(' => "shift-0x0A",
    'J' => "shift-j", 'W' => "shift-w",  '.' => "0x34", '>' => "shift-0x34", ')' => "shift-0x0B",
    'K' => "shift-k", 'X' => "shift-x",  '/' => "0x35", '?' => "shift-0x35",
    'L' => "shift-l", 'Y' => "shift-y",  ' ' => "spc",
    'M' => "shift-m", 'Z' => "shift-z", "\n" => "ret",
);


sub sendKeys {
    my ($self, @keys) = @_;
    foreach my $key (@keys) {
        $key = $charToKey{$key} if exists $charToKey{$key};
        $self->sendMonitorCommand("sendkey $key");
    }
}


sub sendChars {
    my ($self, $chars) = @_;
    $self->nest("sending keys ‘$chars’", sub {
        $self->sendKeys(split //, $chars);
    });
}


# Sleep N seconds (in virtual guest time, not real time).
sub sleep {
    my ($self, $time) = @_;
    $self->succeed("sleep $time");
}


# Forward a TCP port on the host to a TCP port on the guest.  Useful
# during interactive testing.
sub forwardPort {
    my ($self, $hostPort, $guestPort) = @_;
    $hostPort = 8080 unless defined $hostPort;
    $guestPort = 80 unless defined $guestPort;
    $self->sendMonitorCommand("hostfwd_add tcp::$hostPort-:$guestPort");
}


1;
