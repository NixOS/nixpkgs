{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ktop";
  version = "0.4.1";
  excludedPackages = [ ".ci" ];

  src = fetchFromGitHub {
    owner = "vladimirvivien";
    repo = "ktop";
    rev = "v${version}";
    hash = "sha256-5iFFYTZq5DcMYVnW90MKVDchVXzjXOPd5BeYcrqL9pQ=";
  };

  vendorHash = "sha256-qNrjyMMsFE2FmIJc46fYq08b3XFFZeLlspth5anjMm8=";
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
    description = "Top-like tool for your Kubernetes cluster";
    mainProgram = "ktop";
    longDescription = ''
      Following the tradition of Unix/Linux top tools, ktop is a tool that displays useful metrics information about nodes, pods, and other workload resources running in a Kubernetes cluster.
    '';
    homepage = "https://github.com/vladimirvivien/ktop/";
    license = licenses.asl20;
    maintainers = with maintainers; [ qjoly ];
  };
}
