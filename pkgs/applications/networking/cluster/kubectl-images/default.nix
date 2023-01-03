{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubectl-images";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "chenjiandongx";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-aDWtLTnMQklTU6X6LF0oBuh1317I5/kiEZVePgJjIdU";
  };

  vendorSha256 = "sha256-FxaOOFwDf3LNREOlA7frqhDXzc91LC3uJev3kzLDEy8";

  postInstall = ''
    mv $out/bin/cmd $out/bin/kubectl-images
  '';

  meta = with lib; {
    description = "Show container images used in the cluster.";
    homepage = "https://github.com/chenjiandongx/kubectl-images";
    changelog = "https://github.com/chenjiandongx/kubectl-images/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ maintainers.ivankovnatsky ];
  };
}
