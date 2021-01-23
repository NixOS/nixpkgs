{ lib, stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "helm";
  version = "3.4.2";

  src = fetchFromGitHub {
    owner = "helm";
    repo = "helm";
    rev = "v${version}";
    sha256 = "17bb0f2w0qn6zq5isskckwqlscqig2d6pra3f7mfwilnckg1lj9s";
  };
  vendorSha256 = "0ycp0i26rf3c96i4nqcbh7rb6i6lk62hljcsgsjyggq3pj3gpb4x";

  doCheck = false;

  subPackages = [ "cmd/helm" ];
  buildFlagsArray = [ "-ldflags=-w -s -X helm.sh/helm/v3/internal/version.version=v${version}" ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    $out/bin/helm completion bash > helm.bash
    $out/bin/helm completion zsh > helm.zsh
    installShellCompletion helm.{bash,zsh}
  '';

  meta = with lib; {
    homepage = "https://github.com/kubernetes/helm";
    description = "A package manager for kubernetes";
    license = licenses.asl20;
    maintainers = with maintainers; [ rlupton20 edude03 saschagrunert Frostman Chili-Man ];
  };
}
