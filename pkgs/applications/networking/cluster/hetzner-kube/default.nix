{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hetzner-kube";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "xetys";
    repo = "hetzner-kube";
    rev = version;
    sha256 = "11202i3340vaz8xh59gwj5x0djcgbzq9jfy2214lcpml71qc85f0";
  };

  modSha256 = "1j04xyjkz7jcqrs5p5z94jqagrzcxjr9m3lyp8i91c0ymxf5m2g3";

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
