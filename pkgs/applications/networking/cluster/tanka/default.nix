{ buildGoModule, fetchFromGitHub, lib, installShellFiles }:

buildGoModule rec {
  pname = "tanka";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-y2HhtYKgC9Y397dZ14eQoPZxqS1fTOXVD8B4wdLIHzM=";
  };

  vendorSha256 = "sha256-vpm2y/CxRNWkz6+AOMmmZH5AjRQWAa6WD5Fnx5lqJYw=";

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
