{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "syncthing-${version}";
  version = "0.12.15";
  rev = "v${version}";

  goPackagePath = "github.com/syncthing/syncthing";

  src = fetchFromGitHub {
    inherit rev;
    owner = "syncthing";
    repo = "syncthing";
    sha256 = "0g4sj509h45iq6g7b0pl88rbbn7c7s01774yjc6bl376x1xrl6a1";
  };

  goDeps = ./deps.nix;

  postPatch = ''
    # Mostly a cosmetic change
    sed -i 's,unknown-dev,${version},g' cmd/syncthing/main.go
  '';

  preBuild = ''
    export buildFlagsArray+=("-tags" "noupgrade release")
  '';

  meta = {
    knownVulnerabilities = [ "CVE-2017-1000420" ];
    homepage = https://www.syncthing.net/;
    description = "Open Source Continuous File Synchronization";
    license = stdenv.lib.licenses.mpl20;
    platforms = with stdenv.lib.platforms; linux ++ freebsd ++ openbsd ++ netbsd;
  };
}
