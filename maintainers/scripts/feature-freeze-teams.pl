#!/usr/bin/env nix-shell
#!nix-shell -i perl -p perl -p perlPackages.JSON perlPackages.LWPUserAgent perlPackages.LWPProtocolHttps perlPackages.TermReadKey

# This script generates a list of teams to ping for the Feature Freeze announcement on Discourse.
# It's intended to be used by Release Managers before creating such posts.
#
# The script interactively reads a GitHub username and a corresponding GitHub Personal Access token.
# This is required to access the GitHub Teams API so the token needs at least the read:org privilege.

## no critic (InputOutput::RequireCheckedSyscalls, InputOutput::ProhibitBacktickOperators)
use strict;
use warnings;
use Carp;
use Cwd 'abs_path';
use File::Basename;
use JSON qw(decode_json);
use LWP::UserAgent;
use Term::ReadKey qw(ReadLine ReadMode);

sub github_team_members {
    my ($team_name, $username, $token) = @_;
    my @ret;

    my $req = HTTP::Request->new('GET', "https://api.github.com/orgs/NixOS/teams/$team_name/members", [ 'Accept' => 'application/vnd.github.v3+json' ]);
    $req->authorization_basic($username, $token);
    my $response = LWP::UserAgent->new->request($req);

    if ($response->is_success) {
        my $content = decode_json($response->decoded_content);
        foreach (@{$content}) {
            push @ret, $_->{'login'};
        }
    } else {
        print {*STDERR} "!! Requesting members of GitHub Team '$team_name' failed: " . $response->status_line;
    }

    return \@ret;
}

# Read GitHub credentials
print {*STDERR} 'GitHub username: ';
my $github_user = ReadLine(0);
ReadMode('noecho');
print {*STDERR} 'GitHub personal access token (no echo): ';
my $github_token = ReadLine(0);
ReadMode('restore');
print {*STDERR} "\n";
chomp $github_user;
chomp $github_token;

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
print {*STDERR} "\n";
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
    print {*STDERR} "$team_config->{shortName}:";
    # GitHub Teams
    my @github_members;
    if (defined $team_config->{github}) {
        print {*STDERR} " \@NixOS/$team_config->{github}";
        push @github_members, @{github_team_members($team_config->{github}, $github_user, $github_token)};
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
            print {*STDERR} " \@$github_handle";
        }
    }

    print {*STDERR} "\n";
}
