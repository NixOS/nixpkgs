{ lib
, buildGoModule
, fetchFromGitHub
, iproute2
, iptables
, makeWrapper
, procps
}:

buildGoModule rec {
  pname = "gvisor";
  version = "20220905.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "gvisor";
    rev = "442a3cd44a0858ac2a8e773b6fbba67cf3bd3767";
    sha256 = "sha256-LKY7AKAHX29eGuXRrkCVCFl/bdHAVOC0QNZfzlpXqwc=";
  };

  vendorSha256 = "sha256-Fn8A8iwTv0lNI9ZBJkq3SlRelnAGIQY0GInTxaCzSAU=";

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [ "-s" "-w" ];

  subPackages = [ "runsc" "shim" ];

  postInstall = ''
    # Needed for the 'runsc do' subcomand
    wrapProgram $out/bin/runsc \
      --prefix PATH : ${lib.makeBinPath [ iproute2 iptables procps ]}
    mv $out/bin/shim $out/bin/containerd-shim-runsc-v1
  '';

  meta = with lib; {
    description = "Application Kernel for Containers";
    homepage = "https://github.com/google/gvisor";
    license = licenses.asl20;
    maintainers = with maintainers; [ andrew-d gpl ];
    platforms = [ "x86_64-linux" ];
  };
}
