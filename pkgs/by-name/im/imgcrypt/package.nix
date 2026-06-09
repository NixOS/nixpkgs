{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "imgcrypt";
  version = "1.1.10";

  src = fetchFromGitHub {
    owner = "containerd";
    repo = "imgcrypt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-81jfoWHYYenGQFcQI9kk8uPnv6FcyOtcJjpo1ykdtOI=";
  };

  vendorHash = null;

  ldflags = [
    "-X github.com/containerd/containerd/version.Version=${finalAttrs.version}"
  ];

  subPackages = [
    "cmd/ctd-decoder"
    "cmd/ctr"
  ];

  postFixup = ''
    mv $out/bin/ctr $out/bin/ctr-enc
  '';

  meta = {
    description = "Image encryption library and command line tool";
    homepage = "https://github.com/containerd/imgcrypt";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ mikroskeem ];
  };
})
