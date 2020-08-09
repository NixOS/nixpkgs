{ buildGoModule, fetchFromGitHub, lib, installShellFiles }:

buildGoModule rec {
  pname = "tanka";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = pname;
    rev = "v${version}";
    sha256 = "0hp10qgalglsdhh6z6v4azh2hsr89mdrv1g5lssfl5jyink409yd";
  };

  vendorSha256 = "15x8fqz2d2793ivgxpd9jyr34njzi1xpyxdlfyj1b01n2vr3xg4m";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=-s -w -X main.Version=${version}" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    echo "complete -C $out/bin/tk tk" > tk.bash
    installShellCompletion tk.bash
  '';

  meta = with lib; {
    description = "Flexible, reusable and concise configuration for Kubernetes";
    homepage = "https://github.com/grafana/tanka/";
    license = licenses.asl20;
    maintainers = with maintainers; [ mikefaille ];
    platforms = platforms.unix;
  };
}
