{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "imgcrypt";
  version = "1.1.10";

  src = fetchFromGitHub {
    owner = "containerd";
    repo = "imgcrypt";
    rev = "v${version}";
    hash = "sha256-81jfoWHYYenGQFcQI9kk8uPnv6FcyOtcJjpo1ykdtOI=";
  };

  vendorHash = null;

  ldflags = [
    "-X github.com/containerd/containerd/version.Version=${version}"
  ];

  subPackages = [
    "cmd/ctd-decoder"
    "cmd/ctr"
  ];

  postFixup = ''
    mv $out/bin/ctr $out/bin/ctr-enc
  '';

  meta = with lib; {
    description = "Image encryption library and command line tool";
    homepage = "https://github.com/containerd/imgcrypt";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mikroskeem ];
  };
}
