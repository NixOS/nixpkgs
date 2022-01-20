{ buildGoModule, fetchFromGitHub, lib, installShellFiles }:

buildGoModule rec {
  pname = "tanka";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-SMPStxqzoeooBoqUJdFK6Zg3dzbNHrB/tv8iwa8GdbM=";
  };

  vendorSha256 = "sha256-pqwdxFFcATfxGmz6quIH8OL4U2DZKmuVyOLEct2nBlE=";

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
