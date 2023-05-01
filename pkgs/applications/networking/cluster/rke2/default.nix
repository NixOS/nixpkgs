{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rke2";
  version = "1.26.4+rke2r1";

  src = fetchFromGitHub {
    owner = "rancher";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-orxRyCgj3pGLlBoUEjVpyWKw4zfvN4DtaymYKEBXNbs=";
  };

  vendorHash = "sha256-YeWyMEwatKuT4FWIpaDK6/xo5TG5IOecoYR+uVidOW4=";

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" "-X github.com/k3s-io/k3s/pkg/version.Version=v${version}" ];

  meta = with lib; {
    homepage = "https://github.com/rancher/rke2";
    description = "RKE2, also known as RKE Government, is Rancher's next-generation Kubernetes distribution.";
    changelog = "https://github.com/rancher/rke2/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ zygot ];
  };
}
