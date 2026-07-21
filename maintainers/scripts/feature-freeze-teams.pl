#!/usr/bin/env nix-shell
#!nix-shell -i perl -p perl -p perlPackages.JSON github-cli

# This script generates a list of teams to ping for the Feature Freeze announcement on Discourse.
# It's intended to be used by Release Managers before creating such posts.
#
# The script uses the credentials from the GitHub CLI (gh)
# This is required to access the GitHub Teams API so it needs at least the read:org privilege.

## no critic (InputOutput::RequireCheckedSyscalls, InputOutput::ProhibitBacktickOperators)
use strict;
use warnings;
use Carp;
use Cwd 'abs_path';
use File::Basename;
use JSON qw(decode_json);

sub github_team_members {
    my ($team_name) = @_;
    my @ret;

    my $content = decode_json(`gh api orgs/NixOS/teams/$team_name/members`);
    foreach (@{$content}) {
        push @ret, $_->{'login'};
    }

    return \@ret;
}

`gh auth status` or die "`gh` comes from `pkgs.github-cli`, or in one command:
nix-shell -p github-cli --run 'gh auth login'\n";

# Read nix output
my $nix_version = `nix --version`;
my $out;
my $lib_path = abs_path(dirname(__FILE__)) . '../../../lib';
if ($nix_version =~ m/2[.]3[.]/msx) {
    $out = `nix eval --json '(import $lib_path).teams'` || croak 'nix eval failed';
} else {
    $out = `nix --extra-experimental-features nix-command eval --json --impure --expr '(import $lib_path).teams'` || croak('nix eval failed');
}
my $data = decode_json($out);

# Process teams
while (my ($team_nix_key, $team_config) = each %{$data}) {
    # Ignore teams that don't want to be or can't be pinged
    if (not defined $team_config->{enableFeatureFreezePing} or not $team_config->{enableFeatureFreezePing}) {
        next;
    }
    if (not defined $team_config->{shortName}) {
        print {*STDERR} "!! The team with the nix key '$team_nix_key' has no shortName set - ignoring";
        next;
    }
    #  Team name
    print {*STDOUT} "$team_config->{shortName}:";
    # GitHub Teams
    my @github_members;
    if (defined $team_config->{github}) {
        print {*STDOUT} " \@NixOS/$team_config->{github}";
        push @github_members, @{github_team_members($team_config->{github})};
    }
    my %github_members = map { $_ => 1 } @github_members;
    # Members
    if (defined $team_config->{members}) {
        foreach (@{$team_config->{members}}) {
            my %user = %{$_};
            my $github_handle = $user{'github'};
            # Ensure we don't ping team members twice (as team member and directly)
            if (defined $github_members{$github_handle}) {
                next;
            }
            print {*STDOUT} " \@$github_handle";
        }
    }

    print {*STDOUT} "\n";
}

print {*STDOUT} "Everyone else: \@NixOS/nixpkgs-committers\n";
