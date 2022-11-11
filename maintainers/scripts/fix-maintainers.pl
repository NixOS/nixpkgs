#!/usr/bin/env nix-shell
#!nix-shell -i perl -p perl -p perlPackages.LWP -p perlPackages.LWPProtocolHttps -p perlPackages.LWPUserAgent -p perlPackages.JSON -p perlPackages.PathTiny
use LWP::UserAgent;
use JSON;
use Path::Tiny;
use strict;
use warnings;

my $maintainers_list_nix = "../maintainer-list.nix";
my $maintainers_json = from_json(`nix-instantiate --json --eval --expr 'builtins.fromJSON (builtins.toJSON (import $maintainers_list_nix))'`);

STDOUT->autoflush(1);

my $ua = LWP::UserAgent->new();

keys %$maintainers_json; # reset the internal iterator so a prior each() doesn't affect the loop
while(my($k, $v) = each %$maintainers_json) {
    my $current_user = %$v{'github'};
    if (!defined $current_user) {
        print "$k has no github handle\n";
        next;
    }
    my $github_id = %$v{'githubId'};
    if (!defined $github_id) {
        print "$k has no githubId\n";
        next;
    }
    my $url = 'https://api.github.com/user/' . $github_id;
    my $resp = $ua->get(
        $url,
        "Authorization" => "Token $ENV{GH_TOKEN}"
    );

    if ($resp->header("X-RateLimit-Remaining") == 0) {
        my $ratelimit_reset = $resp->header("X-RateLimit-Reset");
        print "Request limit exceeded, waiting until " . scalar localtime $ratelimit_reset . "\n";
        sleep($ratelimit_reset - time() + 5);
    }
    if ($resp->code != 200) {
        print $current_user . " likely deleted their github account\n";
        next;
    }
    my $resp_json = from_json($resp->content);
    my $api_user = %$resp_json{"login"};
    if ($current_user ne $api_user) {
        print $current_user . " is now known on github as " . $api_user . ". Editing maintainer-list.nix…\n";
        my $file = path($maintainers_list_nix);
        my $data = $file->slurp_utf8;
        $data =~ s/github = "$current_user";$/github = "$api_user";/m;
        $file->spew_utf8($data);
    }
}
