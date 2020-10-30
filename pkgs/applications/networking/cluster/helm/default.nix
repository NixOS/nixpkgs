{ stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "helm";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "helm";
    repo = "helm";
    rev = "v${version}";
    sha256 = "1z5s8c6yrc1v2y54lx2mbyz31schzpaz2r304m0wwxhn06p43sl0";
  };
  vendorSha256 = "0vcvmbvfmj0bi5msjhy9qcqabiscjpfqpnb1lxy49mshs902qc14";

  doCheck = false;

  subPackages = [ "cmd/helm" ];
  buildFlagsArray = [ "-ldflags=-w -s -X helm.sh/helm/v3/internal/version.version=v${version}" ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    $out/bin/helm completion bash > helm.bash
    $out/bin/helm completion zsh > helm.zsh
    installShellCompletion helm.{bash,zsh}
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/kubernetes/helm";
    description = "A package manager for kubernetes";
    license = licenses.asl20;
    maintainers = with maintainers; [ rlupton20 edude03 saschagrunert Frostman Chili-Man ];
  };
}
