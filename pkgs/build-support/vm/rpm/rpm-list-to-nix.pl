#! /usr/bin/perl -w

use strict;

my $list = shift;
my $expr = shift;

open LIST, "<$list";
open NEW, ">$list.tmp";
open EXPR, ">$expr";

print EXPR "{fetchurl}: [\n";

my $baseURL;

while (<LIST>) {

    if (/^\s*baseURL\s+(\S+)\s*$/) {
        $baseURL = $1;
        print NEW "baseURL $baseURL\n";
    } 
    
    elsif (/^\s*(\S+)(\s+([a-z0-9]+))?\s*$/) {
        my $pkgName = $1;
        my $url = "$baseURL/$pkgName";
        my $hash = $3;
        if (!defined $hash) {
            $hash = `nix-prefetch-url '$url'`;
            die "fetch of `$url' failed" if ($? != 0);
            chomp $hash;
        }
        print NEW "$pkgName $hash\n";
        if (length $hash == 32) {
            print EXPR "  (fetchurl {url=$url; md5=\"$hash\";})\n";
        } else {
            print EXPR "  (fetchurl {url=$url; sha256=\"$hash\";})\n";
        }
    }

    else {
        die "invalid line"
    }
}

print EXPR "]\n";

close LIST;
close NEW;
close EXPR;

rename "$list\.tmp", "$list" or die "cannot rename";
