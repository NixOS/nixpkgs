{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kail";
  version = "0.17.4";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  src = fetchFromGitHub {
    owner = "boz";
    repo = "kail";
    rev = "v${version}";
    sha256 = "sha256-G8U7UEYhgkcFbKeHOjbpf9AY6NW0hBgv6aARuzapE3M=";
  };

  vendorHash = "sha256-u6/LsLphaqYswJkAuqgrgknnm+7MnaeH+kf9BPcdtrc=";

  meta = with lib; {
    description = "Kubernetes log viewer";
    homepage = "https://github.com/boz/kail";
    license = licenses.mit;
    maintainers = with maintainers; [
      offline
      vdemeester
    ];
    mainProgram = "kail";
  };
}
