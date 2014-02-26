{ stdenv, fetchurl, runCommand, python, perl, cdrkit, pathsFromGraph }:

{ packages ? []
, mirror ? "http://ftp.gwdg.de/pub/linux/sources.redhat.com/cygwin"
, extraContents ? []
}:

let
  cygPkgList = if stdenv.is64bit then fetchurl {
    url = "${mirror}/x86_64/setup.ini";
    sha256 = "142f8zyfwgi6s2djxv3z5wn0ysl94pxwa79z8rjfqz4kvnpgz120";
  } else fetchurl {
    url = "${mirror}/x86/setup.ini";
    sha256 = "1v596lln2iip5h7wxjnig5rflzvqa21zzd2iyhx07zs28q5h76i9";
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
