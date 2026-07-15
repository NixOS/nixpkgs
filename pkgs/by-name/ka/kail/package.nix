{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kail";
  version = "0.17.4";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  src = fetchFromGitHub {
    owner = "boz";
    repo = "kail";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-G8U7UEYhgkcFbKeHOjbpf9AY6NW0hBgv6aARuzapE3M=";
  };

  vendorHash = "sha256-u6/LsLphaqYswJkAuqgrgknnm+7MnaeH+kf9BPcdtrc=";

  meta = {
    description = "Kubernetes log viewer";
    homepage = "https://github.com/boz/kail";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      vdemeester
    ];
    mainProgram = "kail";
  };
})
