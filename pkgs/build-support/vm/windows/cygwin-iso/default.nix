{ stdenv, fetchurl, runCommand, python, perl, cdrkit, pathsFromGraph }:

{ packages ? []
, mirror ? "http://ftp.gwdg.de/pub/linux/sources.redhat.com/cygwin"
, extraContents ? []
}:

let
  cygPkgList = fetchurl {
    url = "${mirror}/x86_64/setup.ini";
    sha256 = "19vfm7zr8kcp1algmggk8vsilkccycx22mdf0ynfl6lcmp6dkfsz";
  };

  makeCygwinClosure = { packages, packageList }: let
    expr = import (runCommand "cygwin.nix" { buildInputs = [ python ]; } ''
      python ${./mkclosure.py} "${packages}" ${toString packageList} > "$out"
    '');
    gen = { url, md5 }: {
      source = fetchurl {
        url = "${mirror}/${url}";
        inherit md5;
      };
      target = url;
    };
  in map gen expr;

in import <nixpkgs/nixos/lib/make-iso9660-image.nix> {
  inherit (import <nixpkgs> {}) stdenv perl cdrkit pathsFromGraph;
  contents = [
    { source = fetchurl {
        url = "http://cygwin.com/setup-x86_64.exe";
        sha256 = "1bjmq9h1p6mmiqp6f1kvmg94jbsdi1pxfa07a5l497zzv9dsfivm";
      };
      target = "setup.exe";
    }
    { source = cygPkgList;
      target = "setup.ini";
    }
  ] ++ makeCygwinClosure {
    packages = cygPkgList;
    packageList = packages;
  } ++ extraContents;
}
