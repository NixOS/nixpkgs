{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "juicefs";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "juicedata";
    repo = "juicefs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mWx9+02+yjIShjiFoWMNBGiChPUq23UiID3W8Enplnc=";
  };

  vendorHash = "sha256-3CXp4W3SYnRTpZlksWy+oz4uTVoqJ9FG41jePQPfx/Y=";

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
