{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubecolor";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9fL1zuhQ1B8QpJXcGVxg8mqIQoM5ZhwuE000rDcrrw0=";
  };

  vendorHash = "sha256-Gzz+mCEMQCcLwTiGMB8/nXk7HDAEGkEapC/VOyXrn/Q=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  meta = with lib; {
    description = "Colorizes kubectl output";
    mainProgram = "kubecolor";
    homepage = "https://github.com/kubecolor/kubecolor";
    changelog = "https://github.com/kubecolor/kubecolor/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      ivankovnatsky
      SuperSandro2000
      applejag
    ];
  };
}
