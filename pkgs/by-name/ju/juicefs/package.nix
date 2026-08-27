{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "juicefs";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "juicedata";
    repo = "juicefs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-S8sQ14FaHW8gp0OA+cea1YMnV1o1M7AyKjh6FcQjXOg=";
  };

  vendorHash = "sha256-JoWsoUFbP2v9g2RUBp5wK/TdguWcYPwhH8hqatzyBew=";

  excludedPackages = [ "sdk/java/libjfs" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/juicedata/juicefs/pkg/version.version=${finalAttrs.version}"
  ];

  doCheck = false; # requires network access

  postInstall = ''
    ln -s $out/bin/juicefs $out/bin/mount.juicefs
  '';

  meta = {
    description = "Distributed POSIX file system built on top of Redis and S3";
    homepage = "https://www.juicefs.com/";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
