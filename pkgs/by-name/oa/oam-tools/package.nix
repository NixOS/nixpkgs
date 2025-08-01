{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "oam-tools";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "owasp-amass";
    repo = "oam-tools";
    tag = "v${version}";
    hash = "sha256-vt4V8em8Iaz3BVKIqlcAv+VIpJtD58xb3QrkIr4tYuU=";
  };

  vendorHash = "sha256-yFKYZlA06yE48Wiz0cKgD57JEREwYyYkLM1NZPV8+Xc=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Analysis and management tools for an Open Asset Model database";
    homepage = "https://github.com/owasp-amass/oam-tools";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
