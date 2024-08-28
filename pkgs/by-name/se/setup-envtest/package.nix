{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "setup-envtest";
  version = "0.18.2";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "controller-runtime";
    rev = "v${version}";
    hash = "sha256-fQgWwndxzBIi3zsNMYvFDXjetnaQF0NNK+qW8j4Wn/M=";
  } + "/tools/setup-envtest";

  vendorHash = "sha256-Xr5b/CRz/DMmoc4bvrEyAZcNufLIZOY5OGQ6yw4/W9k=";

  ldflags = [ "-s" "-w" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Tool that manages binaries for envtest, allowing the download of new binaries, listing installed and available ones, and cleaning up versions";
    homepage = "https://github.com/kubernetes-sigs/controller-runtime/tree/v${version}/tools/setup-envtest";
    license = licenses.asl20;
    maintainers = with maintainers; [ arikgrahl ];
    mainProgram = "setup-envtest";
  };
}
