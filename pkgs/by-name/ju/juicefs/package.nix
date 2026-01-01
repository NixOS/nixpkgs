{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "juicefs";
<<<<<<< HEAD
  version = "1.3.1";
=======
  version = "1.3.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "juicedata";
    repo = "juicefs";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-FACkhBYlJK3NcgYliqT/18djVB7sAo53oqosdFFkAtI=";
=======
    hash = "sha256-JQckOEoM40K5Tlq1Ti/vBIDdKqrtfnfy3JeJmp9K93o=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  vendorHash = "sha256-LE6bpFSHhIRKaGlgn8nU8leOfcNH1ruKRv3vHZu0n/s=";

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

<<<<<<< HEAD
  meta = {
    description = "Distributed POSIX file system built on top of Redis and S3";
    homepage = "https://www.juicefs.com/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dit7ya ];
=======
  meta = with lib; {
    description = "Distributed POSIX file system built on top of Redis and S3";
    homepage = "https://www.juicefs.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
