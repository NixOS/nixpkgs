{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubecolor";
  version = "0.0.20";

  src = fetchFromGitHub {
    owner = "hidetatz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-bKHEp9AxH1CcObhNzD3BkNOdyWZu7JrEdsXpo49wEcI=";
  };

  vendorSha256 = "sha256-C1K7iEugA4HBLthcOI7EZ6H4YHW6el8X6FjVN1BeJR0=";

  meta = with lib; {
    description = "Colorizes kubectl output";
    homepage = "https://github.com/hidetatz/kubecolor";
    changelog = "https://github.com/hidetatz/kubecolor/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ maintainers.ivankovnatsky ];
  };
}
