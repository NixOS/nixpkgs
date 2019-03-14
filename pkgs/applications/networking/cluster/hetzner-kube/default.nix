{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "hetzner-kube-${version}";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "xetys";
    repo = "hetzner-kube";
    rev = "${version}";
    sha256 = "11202i3340vaz8xh59gwj5x0djcgbzq9jfy2214lcpml71qc85f0";
  };

  modSha256 = "1mx74nci7j7h44pw1qf5fxkvfnhppj46898f8895ay8hhxd28lbm";

  buildFlagsArray = ''
    -ldflags=
    -X github.com/xetys/hetzner-kube/cmd.version=${version}
  '';

  meta = {
    description = "A CLI tool for provisioning Kubernetes clusters on Hetzner Cloud";
    homepage = https://github.com/xetys/hetzner-kube;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ eliasp ];
    platforms = lib.platforms.unix;
  };
}
