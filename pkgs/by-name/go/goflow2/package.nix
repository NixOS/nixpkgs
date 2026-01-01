{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
<<<<<<< HEAD
  version = "2.2.6";
=======
  version = "2.2.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
buildGoModule {
  pname = "goflow2";
  inherit version;

  src = fetchFromGitHub {
    owner = "netsampler";
    repo = "goflow2";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-PGXBsUDooYEq5RuLRwmTMOxYuXCxhfAo9Ef/75TWPc0=";
=======
    hash = "sha256-nLsl3v4pvFa0d4AejjlUY9y92yKCU3jM5ui2Y+qZ3JY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

<<<<<<< HEAD
  vendorHash = "sha256-fhZ74kSCYd/7P9A9rdQhe8ejNIsFGuSQVO84tIRN+QY=";
=======
  vendorHash = "sha256-E7gWeh8GVFQdxLSZhpl5wAaShooKkC9EJJsulGaoBtE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "High performance sFlow/IPFIX/NetFlow Collector";
    homepage = "https://github.com/netsampler/goflow2";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
