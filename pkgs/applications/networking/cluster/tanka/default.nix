{ buildGoModule, fetchFromGitHub, lib, installShellFiles }:

buildGoModule rec {
  pname = "tanka";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MMQv3/Ft6/FUueGEXGqYWAYy4zc2R6LASbh2x7eJNdQ=";
  };

  vendorSha256 = "sha256-QwtcWzJbusa8BxtG5xmGUgqG0qCMSpkzbmes/x3lnWc=";

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
    mainProgram = "tk";
    platforms = platforms.unix;
  };
}
