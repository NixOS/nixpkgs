{ buildGoModule, fetchFromGitHub, lib, installShellFiles }:

buildGoModule rec {
  pname = "tanka";
  version = "0.17.3";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Khu6ovtcXkqqt3W4OoJ09INgv80tw/6uDcJS+jt3y0Y=";
  };

  vendorSha256 = "sha256-vpm2y/CxRNWkz6+AOMmmZH5AjRQWAa6WD5Fnx5lqJYw=";

  doCheck = false;

  subPackages = [ "cmd/tk" ];

  ldflags = [ "-s" "-w" "-extldflags '-static'" "-X github.com/grafana/tanka/pkg/tanka.CURRENT_VERSION=v${version}" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    echo "complete -C $out/bin/tk tk" > tk.bash
    installShellCompletion tk.bash
  '';

  meta = with lib; {
    description = "Flexible, reusable and concise configuration for Kubernetes";
    homepage = "https://tanka.dev";
    license = licenses.asl20;
    maintainers = with maintainers; [ mikefaille ];
    platforms = platforms.unix;
  };
}
