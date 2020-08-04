{ stdenv, lib, fetchFromGitHub, buildGoModule, makeWrapper }:

buildGoModule rec {
  pname = "kubeval";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "instrumenta";
    repo = "kubeval";
    rev = "${version}";
    sha256 = "05li0qv4q7fy2lr50r6c1r8dhx00jb1g01qmgc72a9zqp378yiq0";
  };

  vendorSha256 = "1kpwvi84i3h1yjprd6m6hn8l9j235931871y3qk9cl0g8q0hv9ja";

  meta = with lib; {
    description = "Validate your Kubernetes configuration files";
    homepage = "https://github.com/instrumenta/kubeval";
    license = licenses.asl20;
    maintainers = with maintainers; [ johanot nicknovitski ];
    platforms = platforms.all;
  };
}
