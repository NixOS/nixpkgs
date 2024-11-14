{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "k2tf";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "sl1pm4t";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zkkRzCTZCvbwBj4oIhTo5d3PvqLMJPzT3zV9jU3PEJs=";
  };

  patches = [
    # update dependencies
    # https://github.com/sl1pm4t/k2tf/pull/111
    (fetchpatch {
      url = "https://github.com/sl1pm4t/k2tf/commit/7e7b778eeb80400cb0dadb1cdea4e617b5738147.patch";
      hash = "sha256-ZGQUuH7u3aNLml6rvOzOxVwSTlbhZLknXbHKeY4lp00=";
    })
  ];

  vendorHash = "sha256-yGuoE1bgwVHk3ym382OC93me9HPlVoNgGo/3JROVC2E=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" "-X main.commit=v${version}" ];

  meta = with lib; {
    description = "Kubernetes YAML to Terraform HCL converter";
    mainProgram = "k2tf";
    homepage = "https://github.com/sl1pm4t/k2tf";
    license = licenses.mpl20;
    maintainers = [ maintainers.flokli ];
  };
}
