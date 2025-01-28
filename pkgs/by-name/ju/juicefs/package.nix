{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "juicefs";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "juicedata";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qe8uhSSLeOsr0FmgoOVeZeIpP4Bv5/Viz5N90PGdc9o=";
  };

  vendorHash = "sha256-TIcxqMMsihV3Rf8WpQM/Ct9CNs3gBKBIx6myXHfca+s=";

  excludedPackages = [ "sdk/java/libjfs" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/juicedata/juicefs/pkg/version.version=${version}"
  ];

  doCheck = false; # requires network access

  postInstall = ''
    ln -s $out/bin/juicefs $out/bin/mount.juicefs
  '';

  meta = with lib; {
    description = "Distributed POSIX file system built on top of Redis and S3";
    homepage = "https://www.juicefs.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
