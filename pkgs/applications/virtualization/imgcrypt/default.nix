{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "imgcrypt";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "containerd";
    repo = pname;
    rev = "v${version}";
    sha256 = "177fs3p2xzwjsffcxqqllx6wi6ghfyqbvfgn95v3q7a2993yqk4k";
  };

  ldflags = [
    "-X github.com/containerd/containerd/version.Version=${version}"
  ];

  vendorSha256 = null;
  subPackages = [ "cmd/ctd-decoder" "cmd/ctr" ];

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
