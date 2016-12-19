{ stdenv, fetchurl, runCommand, python, perl, cdrkit, pathsFromGraph
, arch ? "x86_64"
}:

{ packages ? []
, mirror ? "http://ftp.gwdg.de/pub/linux/sources.redhat.com/cygwin"
, extraContents ? []
}:

let
  cygPkgList = if arch == "x86_64" then fetchurl {
    url = "${mirror}/x86_64/setup.ini";
    sha256 = "0ljsxdkx9s916wp28kcvql3bjx80zzzidan6jicby7i9s3sm96n9";
  } else fetchurl {
    url = "${mirror}/x86/setup.ini";
    sha256 = "1slyj4qha7x649ggwdski9spmyrbs04z2d46vgk8krllg0kppnjv";
  };

  cygwinCross = (import ../../../../.. {
    inherit (stdenv) system;
    crossSystem = {
      libc = "msvcrt";
      platform = {};
      openssl.system = "mingw64";
      inherit arch;
      config = "${arch}-w64-mingw32";
    };
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

in import ../../../../../nixos/lib/make-iso9660-image.nix {
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
