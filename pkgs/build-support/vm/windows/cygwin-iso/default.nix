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

  cygwinCross = (import ../../../../top-level/all-packages.nix {
    inherit (stdenv) system;
    crossSystem = {
      libc = "msvcrt";
      platform = {};
      openssl.system = "mingw64";
    } // (if stdenv.is64bit then {
      config = "x86_64-w64-mingw32";
      arch = "x86_64";
    } else {
      config = "i686-w64-mingw32";
      arch = "i686";
    });
  }).windows.cygwinSetup.crossDrv;

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
  inherit stdenv perl cdrkit pathsFromGraph;
  contents = [
    { source = "${cygwinCross}/bin/setup.exe";
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
