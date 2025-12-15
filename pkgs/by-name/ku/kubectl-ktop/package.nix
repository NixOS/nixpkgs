{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubectl-ktop";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "vladimirvivien";
    repo = "ktop";
    rev = "v${version}";
    sha256 = "sha256-5iFFYTZq5DcMYVnW90MKVDchVXzjXOPd5BeYcrqL9pQ=";
  };

  vendorHash = "sha256-qNrjyMMsFE2FmIJc46fYq08b3XFFZeLlspth5anjMm8=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/vladimirvivien/ktop/buildinfo.Version=v${version}"
    "-X github.com/vladimirvivien/ktop/buildinfo.GitSHA=${src.rev}"
  ];

  postInstall = ''
    ln -s $out/bin/ktop $out/bin/kubectl-ktop
  '';

  meta = {
    description = "Top-like tool for your Kubernetes clusters";
    homepage = "https://github.com/vladimirvivien/ktop";
    changelog = "https://github.com/vladimirvivien/ktop/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ivankovnatsky ];
  };
}
