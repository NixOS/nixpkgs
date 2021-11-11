{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "helm-docs";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "norwoodj";
    repo = "helm-docs";
    rev = "v${version}";
    sha256 = "sha256-eyFuF03rqwfXyjEkqNRkjrJlHBazGYij1EtN0LAKdFk=";
  };

  vendorSha256 = "sha256-aAn969C4UhFGu5/qXIG/rc1cErQIDtPwEA+f0d43y0w=";

  subPackages = [ "cmd/helm-docs" ];
  ldflags = [
    "-w"
    "-s"
    "-X main.version=v${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/norwoodj/helm-docs";
    description = "A tool for automatically generating markdown documentation for Helm charts";
    platforms = platforms.unix;
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ sagikazarmark ];
  };
}
