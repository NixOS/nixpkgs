package Logger;

use strict;
use Thread::Queue;
use XML::Writer;
use Encode qw(decode encode);

sub new {
    my ($class) = @_;
    
    my $logFile = defined $ENV{LOGFILE} ? "$ENV{LOGFILE}" : "/dev/null";
    my $log = new XML::Writer(OUTPUT => new IO::File(">$logFile"));
    
    my $self = {
        log => $log,
        logQueue => Thread::Queue->new()
    };
    
    $self->{log}->startTag("logfile");
    
    bless $self, $class;
    return $self;
}

sub close {
    my ($self) = @_;
    $self->{log}->endTag("logfile");
    $self->{log}->end;
}

sub drainLogQueue {
    my ($self) = @_;
    while (defined (my $item = $self->{logQueue}->dequeue_nb())) {
        $self->{log}->dataElement("line", sanitise($item->{msg}), 'machine' => $item->{machine}, 'type' => 'serial');
    }
}

sub maybePrefix {
    my ($msg, $attrs) = @_;
    $msg = $attrs->{machine} . ": " . $msg if defined $attrs->{machine};
    return $msg;
}

sub nest {
    my ($self, $msg, $coderef, $attrs) = @_;
    print STDERR maybePrefix("$msg\n", $attrs);
    $self->{log}->startTag("nest");
    $self->{log}->dataElement("head", $msg, %{$attrs});
    $self->drainLogQueue();
    eval { &$coderef };
    my $res = $@;
    $self->drainLogQueue();
    $self->{log}->endTag("nest");
    die $@ if $@;
}

sub sanitise {
    my ($s) = @_;
    $s =~ s/[[:cntrl:]\xff]//g;
    $s = decode('UTF-8', $s, Encode::FB_DEFAULT);
    return encode('UTF-8', $s, Encode::FB_CROAK);
}

sub log {
    my ($self, $msg, $attrs) = @_;
    chomp $msg;
    print STDERR maybePrefix("$msg\n", $attrs);
    $self->drainLogQueue();
    $self->{log}->dataElement("line", $msg, %{$attrs});
}

1;
