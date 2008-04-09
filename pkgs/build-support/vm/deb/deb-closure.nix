with import ../../../.. {};

rec {

  debClosureGenerator =
    {name, packages, urlPrefix, toplevel}:
    runCommand "${name}.nix" {} ''
      bunzip2 < ${packages} > ./Packages
      ${perl}/bin/perl -I${dpkg} -w ${./deb-closure.pl} \
        ./Packages ${urlPrefix} ${toString toplevel} > $out
    '';


  commonPackages = [
    "base-passwd"
    "dpkg"
    "libc6-dev"
    "perl"
    "sysvinit"
    "bash"
    "gzip"
    "bzip2"
    "tar"
    "grep"
    "findutils"
    "g++"
    "make"
    "curl"
    "patch"
    "diff"
  ];

  
  # Ubuntu 7.10 "Gutsy Gibbon", i386.

  ubuntu710i386Packages = fetchurl {
    url = mirror://ubuntu/dists/gutsy/main/binary-i386/Packages.bz2;
    sha1 = "8b52ee3d417700e2b2ee951517fa25a8792cabfd";
  };

  ubuntu710i386Debs = debClosureGenerator {
    name = "ubuntu-7.10-gutsy-i386";
    packages = ubuntu710i386Packages;
    urlPrefix = mirror://ubuntu;
    toplevel = commonPackages;
  };


  # Debian 4.0r3 "Etch", i386.

  debian40r3i386Packages = fetchurl {
    url = mirror://debian/dists/etch/main/binary-i386/Packages.bz2;
    sha256 = "7a8f2777315d71fd7321d1076b3bf5f76afe179fe66c2ce8e1ff4baed6424340";
  };

  debian40r3i386Debs = debClosureGenerator {
    name = "debian-4.0r3-etch-i386";
    packages = debian40r3i386Packages;
    urlPrefix = mirror://debian;
    toplevel = commonPackages;
  };

  
}
