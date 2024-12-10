{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ktop";
  version = "0.3.5";
  excludedPackages = [ ".ci" ];

  src = fetchFromGitHub {
    owner = "vladimirvivien";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-nkIRVt2kqsE9QBYvvHmupohnzH+OBcwWwV16rMePw4I=";
  };

  vendorHash = "sha256-IiAMmHOq69WMT2B1q9ZV2fGDnLr7AbRm1P7ACSde2FE=";
  ldflags = [
    "-s"
    "-w"
    "-X github.com/vladimirvivien/ktop/buildinfo.Version=v${version}"
  ];

  postInstall = ''
    rm $out/bin/hack
  '';

  doCheck = false;

  meta = with lib; {
    description = "A top-like tool for your Kubernetes cluster";
    mainProgram = "ktop";
    longDescription = ''
      Following the tradition of Unix/Linux top tools, ktop is a tool that displays useful metrics information about nodes, pods, and other workload resources running in a Kubernetes cluster.
    '';
    homepage = "https://github.com/vladimirvivien/ktop/";
    license = licenses.asl20;
    maintainers = with maintainers; [ qjoly ];
  };
}
