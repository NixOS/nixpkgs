{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "helm-docs";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "norwoodj";
    repo = "helm-docs";
    rev = "v${version}";
    sha256 = "sha256-476ZhjRwHlNJFkHzY8qQ7WbAUUpFNSoxXLGX9esDA/E=";
  };

  vendorSha256 = "sha256-xXwunk9rmzZEtqmSo8biuXnAjPp7fqWdQ+Kt9+Di9N8=";

  subPackages = [ "cmd/helm-docs" ];
  ldflags = [
    "-w"
    "-s"
    "-X main.version=${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/norwoodj/helm-docs";
    description = "A tool for automatically generating markdown documentation for Helm charts";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ sagikazarmark ];
  };
}
