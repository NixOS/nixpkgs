{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "imgcrypt";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "containerd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ytoxdwmyg7IlJOhC6FPI9dnoiptEQrlAAPV57/O3M4U=";
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
