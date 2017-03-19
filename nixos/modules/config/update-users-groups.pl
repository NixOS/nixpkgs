use strict;
use File::Path qw(make_path);
use File::Slurp;
use JSON;

make_path("/var/lib/nixos", { mode => 0755 });


sub hashPassword {
    my ($password) = @_;
    my $salt = "";
    my @chars = ('.', '/', 0..9, 'A'..'Z', 'a'..'z');
    $salt .= $chars[rand 64] for (1..8);
    return crypt($password, '$6$' . $salt . '$');
}


# Functions for allocating free GIDs/UIDs. FIXME: respect ID ranges in
# /etc/login.defs.
sub allocId {
    my ($used, $idMin, $idMax, $up, $getid) = @_;
    my $id = $up ? $idMin : $idMax;
    while ($id >= $idMin && $id <= $idMax) {
        if (!$used->{$id} && !defined &$getid($id)) {
            $used->{$id} = 1;
            return $id;
        }
        $used->{$id} = 1;
        if ($up) { $id++; } else { $id--; }
    }
    die "$0: out of free UIDs or GIDs\n";
}

my (%gidsUsed, %uidsUsed);

sub allocGid {
    return allocId(\%gidsUsed, 400, 499, 0, sub { my ($gid) = @_; getgrgid($gid) });
}

sub allocUid {
    my ($isSystemUser) = @_;
    my ($min, $max, $up) = $isSystemUser ? (400, 499, 0) : (1000, 29999, 1);
    return allocId(\%uidsUsed, $min, $max, $up, sub { my ($uid) = @_; getpwuid($uid) });
}


# Read the declared users/groups.
my $spec = decode_json(read_file($ARGV[0]));

# Don't allocate UIDs/GIDs that are already in use.
foreach my $g (@{$spec->{groups}}) {
    $gidsUsed{$g->{gid}} = 1 if defined $g->{gid};
}

foreach my $u (@{$spec->{users}}) {
    $uidsUsed{$u->{uid}} = 1 if defined $u->{uid};
}

# Read the current /etc/group.
sub parseGroup {
    chomp;
    my @f = split(':', $_, -4);
    my $gid = $f[2] eq "" ? undef : int($f[2]);
    $gidsUsed{$gid} = 1 if defined $gid;
    return ($f[0], { name => $f[0], password => $f[1], gid => $gid, members => $f[3] });
}

my %groupsCur = -f "/etc/group" ? map { parseGroup } read_file("/etc/group") : ();

# Read the current /etc/passwd.
sub parseUser {
    chomp;
    my @f = split(':', $_, -7);
    my $uid = $f[2] eq "" ? undef : int($f[2]);
    $uidsUsed{$uid} = 1 if defined $uid;
    return ($f[0], { name => $f[0], fakePassword => $f[1], uid => $uid,
        gid => $f[3], description => $f[4], home => $f[5], shell => $f[6] });
}

my %usersCur = -f "/etc/passwd" ? map { parseUser } read_file("/etc/passwd") : ();

# Read the groups that were created declaratively (i.e. not by groups)
# in the past. These must be removed if they are no longer in the
# current spec.
my $declGroupsFile = "/var/lib/nixos/declarative-groups";
my %declGroups;
$declGroups{$_} = 1 foreach split / /, -e $declGroupsFile ? read_file($declGroupsFile) : "";

# Idem for the users.
my $declUsersFile = "/var/lib/nixos/declarative-users";
my %declUsers;
$declUsers{$_} = 1 foreach split / /, -e $declUsersFile ? read_file($declUsersFile) : "";


# Generate a new /etc/group containing the declared groups.
my %groupsOut;
foreach my $g (@{$spec->{groups}}) {
    my $name = $g->{name};
    my $existing = $groupsCur{$name};

    my %members = map { ($_, 1) } @{$g->{members}};

    if (defined $existing) {
        $g->{gid} = $existing->{gid} if !defined $g->{gid};
        if ($g->{gid} != $existing->{gid}) {
            warn "warning: not applying GID change of group ‘$name’ ($existing->{gid} -> $g->{gid})\n";
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
        $g->{gid} = allocGid if !defined $g->{gid};
        $g->{password} = "x";
    }

    $g->{members} = join ",", sort(keys(%members));
    $groupsOut{$name} = $g;
}

# Update the persistent list of declarative groups.
write_file($declGroupsFile, { binmode => ':utf8' }, join(" ", sort(keys %groupsOut)));

# Merge in the existing /etc/group.
foreach my $name (keys %groupsCur) {
    my $g = $groupsCur{$name};
    next if defined $groupsOut{$name};
    if (!$spec->{mutableUsers} || defined $declGroups{$name}) {
        print STDERR "removing group ‘$name’\n";
    } else {
        $groupsOut{$name} = $g;
    }
}


# Rewrite /etc/group. FIXME: acquire lock.
my @lines = map { join(":", $_->{name}, $_->{password}, $_->{gid}, $_->{members}) . "\n" }
    (sort { $a->{gid} <=> $b->{gid} } values(%groupsOut));
write_file("/etc/group.tmp", { binmode => ':utf8' }, @lines);
rename("/etc/group.tmp", "/etc/group") or die;
system("nscd --invalidate group");

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
            warn "warning: not applying UID change of user ‘$name’ ($existing->{uid} -> $u->{uid})\n";
            $u->{uid} = $existing->{uid};
        }
    } else {
        $u->{uid} = allocUid($u->{isSystemUser}) if !defined $u->{uid};

        if (defined $u->{initialPassword}) {
            $u->{hashedPassword} = hashPassword($u->{initialPassword});
        } elsif (defined $u->{initialHashedPassword}) {
            $u->{hashedPassword} = $u->{initialHashedPassword};
        }
    }

    # Create a home directory.
    if ($u->{createHome}) {
        make_path($u->{home}, { mode => 0700 }) if ! -e $u->{home};
        chown $u->{uid}, $u->{gid}, $u->{home};
    }

    if (defined $u->{passwordFile}) {
        if (-e $u->{passwordFile}) {
            $u->{hashedPassword} = read_file($u->{passwordFile});
            chomp $u->{hashedPassword};
        } else {
            warn "warning: password file ‘$u->{passwordFile}’ does not exist\n";
        }
    } elsif (defined $u->{password}) {
        $u->{hashedPassword} = hashPassword($u->{password});
    }

    $u->{fakePassword} = $existing->{fakePassword} // "x";
    $usersOut{$name} = $u;
}

# Update the persistent list of declarative users.
write_file($declUsersFile, { binmode => ':utf8' }, join(" ", sort(keys %usersOut)));

# Merge in the existing /etc/passwd.
foreach my $name (keys %usersCur) {
    my $u = $usersCur{$name};
    next if defined $usersOut{$name};
    if (!$spec->{mutableUsers} || defined $declUsers{$name}) {
        print STDERR "removing user ‘$name’\n";
    } else {
        $usersOut{$name} = $u;
    }
}

# Rewrite /etc/passwd. FIXME: acquire lock.
@lines = map { join(":", $_->{name}, $_->{fakePassword}, $_->{uid}, $_->{gid}, $_->{description}, $_->{home}, $_->{shell}) . "\n" }
    (sort { $a->{uid} <=> $b->{uid} } (values %usersOut));
write_file("/etc/passwd.tmp", { binmode => ':utf8' }, @lines);
rename("/etc/passwd.tmp", "/etc/passwd") or die;
system("nscd --invalidate passwd");


# Rewrite /etc/shadow to add new accounts or remove dead ones.
my @shadowNew;
my %shadowSeen;

foreach my $line (-f "/etc/shadow" ? read_file("/etc/shadow") : ()) {
    chomp $line;
    my ($name, $hashedPassword, @rest) = split(':', $line, -9);
    my $u = $usersOut{$name};;
    next if !defined $u;
    $hashedPassword = "!" if !$spec->{mutableUsers};
    $hashedPassword = $u->{hashedPassword} if defined $u->{hashedPassword} && !$spec->{mutableUsers}; # FIXME
    push @shadowNew, join(":", $name, $hashedPassword, @rest) . "\n";
    $shadowSeen{$name} = 1;
}

foreach my $u (values %usersOut) {
    next if defined $shadowSeen{$u->{name}};
    my $hashedPassword = "!";
    $hashedPassword = $u->{hashedPassword} if defined $u->{hashedPassword};
    # FIXME: set correct value for sp_lstchg.
    push @shadowNew, join(":", $u->{name}, $hashedPassword, "1::::::") . "\n";
}

write_file("/etc/shadow.tmp", { binmode => ':utf8', perms => 0600 }, @shadowNew);
rename("/etc/shadow.tmp", "/etc/shadow") or die;
