use strict;
use warnings;
use File::Path qw(make_path);
use File::Slurp;
use Getopt::Long;
use IPC::Open3 qw(open3);
use JSON;
use Time::Piece;

# Keep track of deleted uids and gids.
my $uidMapFile = "/var/lib/nixos/uid-map";
my $uidMap = -e $uidMapFile ? decode_json(read_file($uidMapFile)) : {};

my $gidMapFile = "/var/lib/nixos/gid-map";
my $gidMap = -e $gidMapFile ? decode_json(read_file($gidMapFile)) : {};

my $systemd = "@systemd@";

my $is_dry = ($ENV{'NIXOS_ACTION'} // "") eq "dry-activate";
GetOptions("dry-activate" => \$is_dry);
make_path("/var/lib/nixos", { mode => 0755 }) unless $is_dry;

sub updateFile {
    my ($path, $contents, $perms) = @_;
    return if $is_dry;
    write_file($path, { atomic => 1, binmode => ':utf8', perms => $perms // 0644 }, $contents) or die;
}

# Converts an ISO date to number of days since 1970-01-01
sub dateToDays {
    my ($date) = @_;
    my $time = Time::Piece->strptime($date, "%Y-%m-%d");
    return $time->epoch / 60 / 60 / 24;
}

sub nscdInvalidate {
    system("nscd", "--invalidate", $_[0]) unless $is_dry;
}

sub hashPassword {
    my ($password) = @_;
    my $salt = "";
    my @chars = ('.', '/', 0..9, 'A'..'Z', 'a'..'z');
    $salt .= $chars[rand 64] for (1..8);
    return crypt($password, '$6$' . $salt . '$');
}

sub dry_print {
    if ($is_dry) {
        print STDERR ("$_[1] $_[2]\n")
    } else {
        print STDERR ("$_[0] $_[2]\n")
    }
}


# Functions for allocating free GIDs/UIDs. FIXME: respect ID ranges in
# /etc/login.defs.
sub allocId {
    my ($used, $prevUsed, $idMin, $idMax, $up, $getid) = @_;
    my $id = $up ? $idMin : $idMax;
    while ($id >= $idMin && $id <= $idMax) {
        if (!$used->{$id} && !$prevUsed->{$id} && !defined &$getid($id)) {
            $used->{$id} = 1;
            return $id;
        }
        $used->{$id} = 1;
        if ($up) { $id++; } else { $id--; }
    }
    die "$0: out of free UIDs or GIDs\n";
}

my (%gidsUsed, %uidsUsed, %gidsPrevUsed, %uidsPrevUsed);

sub allocGid {
    my ($name) = @_;
    my $prevGid = $gidMap->{$name};
    if (defined $prevGid && !defined $gidsUsed{$prevGid}) {
        dry_print("reviving", "would revive", "group '$name' with GID $prevGid");
        $gidsUsed{$prevGid} = 1;
        return $prevGid;
    }
    return allocId(\%gidsUsed, \%gidsPrevUsed, 400, 999, 0, sub { my ($gid) = @_; getgrgid($gid) });
}

sub allocUid {
    my ($name, $isSystemUser) = @_;
    my ($min, $max, $up) = $isSystemUser ? (400, 999, 0) : (1000, 29999, 1);
    my $prevUid = $uidMap->{$name};
    if (defined $prevUid && $prevUid >= $min && $prevUid <= $max && !defined $uidsUsed{$prevUid}) {
        dry_print("reviving", "would revive", "user '$name' with UID $prevUid");
        $uidsUsed{$prevUid} = 1;
        return $prevUid;
    }
    return allocId(\%uidsUsed, \%uidsPrevUsed, $min, $max, $up, sub { my ($uid) = @_; getpwuid($uid) });
}

sub loginctl {
    system("${systemd}/bin/loginctl", "--no-legend", "--no-pager", @_);
}

sub loginctlSilent {
    my $pid = open3(my $stdin, my $stdout, undef, "${systemd}/bin/loginctl", "--no-legend", "--no-pager", @_);
    waitpid($pid, 0);
    return $?;
};

# `loginctl show-session`, when called without any session names, "[shows]
# properties [of] the manager itself" (`man 1 loginctl`), where "the manager"
# is the systemd login manager.  If this command completes successfully, we can
# be confident that the login manager is up and running.
if (loginctlSilent("show-session") == 0) {
    *doDisableLinger = sub { loginctl("disable-linger", @_); };
    *doEnableLinger = sub { loginctl("enable-linger", @_); };
} else {
    require Errno; # For magic `%!' in `doDisableLinger`

    my $lingering_dir = "/var/lib/systemd/linger";

    *doDisableLinger = sub {
        foreach my $name (@_) {
            my $file = "${lingering_dir}/${name}";
            unlink $file or do {
                # Don't bother warning about files that are already absent.
                warn "failed to unlink '$file': $!" unless $!{ENOENT};
            };
        }
    };

    *doEnableLinger = sub {
        make_path($lingering_dir);

        foreach my $name (@_) {
            my $file = "${lingering_dir}/${name}";
            open my $fh, ">>", $file or warn "failed to touch '$file': $!";
            close $fh;
        }
    };
}

sub disableLingerRemoved {
    return unless scalar @_;
    dry_print("disabling", "would disable", "lingering for removed user(s) '$_'") foreach @_;
    doDisableLinger(@_) unless $is_dry;
}

sub disableLinger {
    return unless scalar @_;
    dry_print("disabling", "would disable", "lingering for user(s) '$_'") foreach @_;
    doDisableLinger(@_) unless $is_dry;
}

sub enableLinger {
    return unless scalar @_;
    dry_print("enabling", "would enable", "lingering for user(s) '$_'") foreach @_;
    doEnableLinger(@_) unless $is_dry;
}

# Read the declared users/groups
my $spec = decode_json(read_file($ARGV[0]));

# Don't allocate UIDs/GIDs that are manually assigned.
foreach my $g (@{$spec->{groups}}) {
    $gidsUsed{$g->{gid}} = 1 if defined $g->{gid};
}

foreach my $u (@{$spec->{users}}) {
    $uidsUsed{$u->{uid}} = 1 if defined $u->{uid};
}

# Likewise for previously used but deleted UIDs/GIDs.
$uidsPrevUsed{$_} = 1 foreach values %{$uidMap};
$gidsPrevUsed{$_} = 1 foreach values %{$gidMap};


# Read the current /etc/group.
sub parseGroup {
    chomp;
    my @f = split(':', $_, -4);
    my $gid = $f[2] eq "" ? undef : int($f[2]);
    $gidsUsed{$gid} = 1 if defined $gid;
    return ($f[0], { name => $f[0], password => $f[1], gid => $gid, members => $f[3] });
}

my %groupsCur = -f "/etc/group" ? map { parseGroup } read_file("/etc/group", { binmode => ":utf8" }) : ();

# Read the current /etc/passwd.
sub parseUser {
    chomp;
    my @f = split(':', $_, -7);
    my $uid = $f[2] eq "" ? undef : int($f[2]);
    $uidsUsed{$uid} = 1 if defined $uid;
    return ($f[0], { name => $f[0], fakePassword => $f[1], uid => $uid,
        gid => $f[3], description => $f[4], home => $f[5], shell => $f[6] });
}
my %usersCur = -f "/etc/passwd" ? map { parseUser } read_file("/etc/passwd", { binmode => ":utf8" }) : ();

# Read the groups that were created declaratively (i.e. not by groups)
# in the past. These must be removed if they are no longer in the
# current spec.
my $declGroupsFile = "/var/lib/nixos/declarative-groups";
my %declGroups;
$declGroups{$_} = 1 foreach split / /, -e $declGroupsFile ? read_file($declGroupsFile, { binmode => ":utf8" }) : "";

# Idem for the users.
my $declUsersFile = "/var/lib/nixos/declarative-users";
my %declUsers;
$declUsers{$_} = 1 foreach split / /, -e $declUsersFile ? read_file($declUsersFile, { binmode => ":utf8" }) : "";


# Generate a new /etc/group containing the declared groups.
my %groupsOut;
foreach my $g (@{$spec->{groups}}) {
    my $name = $g->{name};
    my $existing = $groupsCur{$name};

    my %members = map { ($_, 1) } @{$g->{members}};

    if (defined $existing) {
        $g->{gid} = $existing->{gid} if !defined $g->{gid};
        if ($g->{gid} != $existing->{gid}) {
            dry_print("warning: not applying", "warning: would not apply", "GID change of group ‘$name’ ($existing->{gid} -> $g->{gid}) in /etc/group");
            $g->{gid} = $existing->{gid};
        }
        $g->{password} = $existing->{password}; # do we want this?
        if ($spec->{mutableUsers}) {
            # Merge in non-declarative group members.
            foreach my $uname (split /,/, $existing->{members} // "") {
                $members{$uname} = 1 if !defined $declUsers{$uname};
            }
        }
    } else {
        $g->{gid} = allocGid($name) if !defined $g->{gid};
        $g->{password} = "x";
    }

    $g->{members} = join ",", sort(keys(%members));
    $groupsOut{$name} = $g;

    $gidMap->{$name} = $g->{gid};
}

# Update the persistent list of declarative groups.
updateFile($declGroupsFile, join(" ", sort(keys %groupsOut)));

# Merge in the existing /etc/group.
foreach my $name (keys %groupsCur) {
    my $g = $groupsCur{$name};
    next if defined $groupsOut{$name};
    if (!$spec->{mutableUsers} || defined $declGroups{$name}) {
        dry_print("removing group", "would remove group", "‘$name’");
    } else {
        $groupsOut{$name} = $g;
    }
}


# Rewrite /etc/group. FIXME: acquire lock.
my @lines = map { join(":", $_->{name}, $_->{password}, $_->{gid}, $_->{members}) . "\n" }
    (sort { $a->{gid} <=> $b->{gid} } values(%groupsOut));
updateFile($gidMapFile, to_json($gidMap, {canonical => 1}));
updateFile("/etc/group", \@lines);
nscdInvalidate("group");

# Generate a new /etc/passwd containing the declared users.
my %usersOut;
foreach my $u (@{$spec->{users}}) {
    my $name = $u->{name};

    # Resolve the gid of the user.
    if ($u->{group} =~ /^[0-9]$/) {
        $u->{gid} = $u->{group};
    } elsif (defined $groupsOut{$u->{group}}) {
        $u->{gid} = $groupsOut{$u->{group}}->{gid} // die;
    } else {
        warn "warning: user ‘$name’ has unknown group ‘$u->{group}’\n";
        $u->{gid} = 65534;
    }

    my $existing = $usersCur{$name};
    if (defined $existing) {
        $u->{uid} = $existing->{uid} if !defined $u->{uid};
        if ($u->{uid} != $existing->{uid}) {
            dry_print("warning: not applying", "warning: would not apply", "UID change of user ‘$name’ ($existing->{uid} -> $u->{uid}) in /etc/passwd");
            $u->{uid} = $existing->{uid};
        }

        # When `mutableUsers` is in effect, only apply the specified lingering
        # setting when creating the user account.
        if ($spec->{mutableUsers}) {
            dry_print("warning: not applying", "warning: would not apply", "lingering setting of mutable user '$name'") if defined $u->{linger};
            delete $u->{linger};
        }
    } else {
        $u->{uid} = allocUid($name, $u->{isSystemUser}) if !defined $u->{uid};

        if (!defined $u->{hashedPassword}) {
            if (defined $u->{initialPassword}) {
                $u->{hashedPassword} = hashPassword($u->{initialPassword});
            } elsif (defined $u->{initialHashedPassword}) {
                $u->{hashedPassword} = $u->{initialHashedPassword};
            }
        }
    }

    # Ensure home directory incl. ownership and permissions.
    if ($u->{createHome} and !$is_dry) {
        make_path($u->{home}, { mode => 0755 }) if ! -e $u->{home};
        chown $u->{uid}, $u->{gid}, $u->{home};
        chmod oct($u->{homeMode}), $u->{home};
    }

    if (defined $u->{hashedPasswordFile}) {
        if (-e $u->{hashedPasswordFile}) {
            $u->{hashedPassword} = read_file($u->{hashedPasswordFile});
            chomp $u->{hashedPassword};
        } else {
            warn "warning: password file ‘$u->{hashedPasswordFile}’ does not exist\n";
        }
    } elsif (defined $u->{password}) {
        $u->{hashedPassword} = hashPassword($u->{password});
    }

    if (!defined $u->{shell}) {
        if (defined $existing) {
            $u->{shell} = $existing->{shell};
        } else {
            warn "warning: no declarative or previous shell for ‘$name’, setting shell to nologin\n";
            $u->{shell} = "/run/current-system/sw/bin/nologin";
        }
    }

    $u->{fakePassword} = $existing->{fakePassword} // "x";
    $usersOut{$name} = $u;

    $uidMap->{$name} = $u->{uid};
}

# Update the persistent list of declarative users.
updateFile($declUsersFile, join(" ", sort(keys %usersOut)));

# Merge in the existing /etc/passwd and gather the names of users whose
# lingering should be disabled.
my @disableLingerRemoved;
foreach my $name (keys %usersCur) {
    my $u = $usersCur{$name};
    next if defined $usersOut{$name};
    if (!$spec->{mutableUsers} || defined $declUsers{$name}) {
        dry_print("removing user", "would remove user", "‘$name’");
        push @disableLingerRemoved, $name;
    } else {
        $usersOut{$name} = $u;
    }
}

# Remove these lingering settings before updating the user DB, as otherwise
# `loginctl disable-linger my-deleted-user` is liable to complain "Failed to
# look up user my-deleted-user: No such process" and fail to remove
# /var/lib/systemd/linger/my-deleted-user.
disableLingerRemoved(@disableLingerRemoved);

# Rewrite /etc/passwd. FIXME: acquire lock.
@lines = map { join(":", $_->{name}, $_->{fakePassword}, $_->{uid}, $_->{gid}, $_->{description}, $_->{home}, $_->{shell}) . "\n" }
    (sort { $a->{uid} <=> $b->{uid} } (values %usersOut));
updateFile($uidMapFile, to_json($uidMap, {canonical => 1}));
updateFile("/etc/passwd", \@lines);
nscdInvalidate("passwd");


# Rewrite /etc/shadow to add new accounts or remove dead ones.
my @shadowNew;
my %shadowSeen;

foreach my $line (-f "/etc/shadow" ? read_file("/etc/shadow", { binmode => ":utf8" }) : ()) {
    chomp $line;
    # struct name copied from `man 3 shadow`
    my ($sp_namp, $sp_pwdp, $sp_lstch, $sp_min, $sp_max, $sp_warn, $sp_inact, $sp_expire, $sp_flag) = split(':', $line, -9);
    my $u = $usersOut{$sp_namp};;
    next if !defined $u;
    $sp_pwdp = "!" if !$spec->{mutableUsers};
    $sp_pwdp = $u->{hashedPassword} if defined $u->{hashedPassword} && !$spec->{mutableUsers}; # FIXME
    $sp_expire = dateToDays($u->{expires}) if defined $u->{expires};
    chomp $sp_pwdp;
    push @shadowNew, join(":", $sp_namp, $sp_pwdp, $sp_lstch, $sp_min, $sp_max, $sp_warn, $sp_inact, $sp_expire, $sp_flag) . "\n";
    $shadowSeen{$sp_namp} = 1;
}

foreach my $u (values %usersOut) {
    next if defined $shadowSeen{$u->{name}};
    my $hashedPassword = "!";
    $hashedPassword = $u->{hashedPassword} if defined $u->{hashedPassword};
    my $expires = "";
    $expires = dateToDays($u->{expires}) if defined $u->{expires};
    # FIXME: set correct value for sp_lstchg.
    push @shadowNew, join(":", $u->{name}, $hashedPassword, "1::::", $expires, "") . "\n";
}

updateFile("/etc/shadow", \@shadowNew, 0640);
{
    my $uid = getpwnam "root";
    my $gid = getgrnam "shadow";
    my $path = "/etc/shadow";
    (chown($uid, $gid, $path) || die "Failed to change ownership of $path: $!") unless $is_dry;
}

# Rewrite /etc/subuid & /etc/subgid to include default container mappings

my $subUidMapFile = "/var/lib/nixos/auto-subuid-map";
my $subUidMap = -e $subUidMapFile ? decode_json(read_file($subUidMapFile)) : {};

my (%subUidsUsed, %subUidsPrevUsed);

$subUidsPrevUsed{$_} = 1 foreach values %{$subUidMap};

sub allocSubUid {
    my ($name, @rest) = @_;

    # TODO: No upper bounds?
    my ($min, $max, $up) = (100000, 100000 * 100, 1);
    my $prevId = $subUidMap->{$name};
    if (defined $prevId && !defined $subUidsUsed{$prevId}) {
        $subUidsUsed{$prevId} = 1;
        return $prevId;
    }

    my $id = allocId(\%subUidsUsed, \%subUidsPrevUsed, $min, $max, $up, sub { my ($uid) = @_; getpwuid($uid) });
    my $offset = $id - 100000;
    my $count = $offset * 65536;
    my $subordinate = 100000 + $count;
    return $subordinate;
}

my @subGids;
my @subUids;
my @disableLinger;
my @enableLinger;
foreach my $u (values %usersOut) {
    my $name = $u->{name};

    foreach my $range (@{$u->{subUidRanges}}) {
        my $value = join(":", ($name, $range->{startUid}, $range->{count}));
        push @subUids, $value;
    }

    foreach my $range (@{$u->{subGidRanges}}) {
        my $value = join(":", ($name, $range->{startGid}, $range->{count}));
        push @subGids, $value;
    }

    if($u->{autoSubUidGidRange}) {
        my $subordinate = allocSubUid($name);
        $subUidMap->{$name} = $subordinate;
        my $value = join(":", ($name, $subordinate, 65536));
        push @subUids, $value;
        push @subGids, $value;
    }

    push @{$u->{linger} ? \@enableLinger : \@disableLinger}, $name if defined $u->{linger};
}

updateFile("/etc/subuid", join("\n", @subUids) . "\n");
updateFile("/etc/subgid", join("\n", @subGids) . "\n");
updateFile($subUidMapFile, encode_json($subUidMap) . "\n");
disableLinger(@disableLinger);
enableLinger(@enableLinger);
