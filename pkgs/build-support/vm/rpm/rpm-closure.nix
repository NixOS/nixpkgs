with import ../../../.. {};

rec {

  rpmClosureGenerator =
    {name, packages, urlPrefix, toplevel}:
    runCommand "${name}.nix" {buildInputs = [perl perlXMLSimple];} ''
      gunzip < ${packages} > ./packages.xml
      perl -w ${./rpm-closure.pl} \
        ./packages.xml ${urlPrefix} ${toString toplevel} > $out
    '';


  commonFedoraPackages = [
    "autoconf"
    "automake"
    "basesystem"
    "bzip2"
    "curl"
    "diffutils"
    "fedora-release"
    "findutils"
    "gawk"
    "gcc-c++"
    "gzip"
    "make"
    "patch"
    "perl"
    "pkgconfig"
    "rpm"
    "rpm-build"
    "tar"
    "unzip"
  ];

  
  # Fedora 8, i386.

  packagesFedora8i386 = fetchurl {
    url = mirror://fedora/linux/releases/8/Fedora/i386/os/repodata/primary.xml.gz;
    sha256 = "0vr9345rrk0vhs4pc9cjp8npdkqz0xqyirv84vhyfn533m9ws36f";
  };

  rpmsFedora8i386 = rpmClosureGenerator {
    name = "fedora-8-i386";
    packages = packagesFedora8i386;
    urlPrefix = mirror://fedora/linux/releases/8/Fedora/i386/os;
    toplevel = [commonFedoraPackages];
  };


}
