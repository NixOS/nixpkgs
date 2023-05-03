{ lib, fetchFromGitHub, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "nali";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "zu1k";
    repo = "nali";
    rev = "v${version}";
    sha256 = "sha256-ZKLxsq7ybom96NKWkioROAVXUoY20zFBZn7ksk4XvT4=";
  };

  vendorHash = "sha256-l3Fs1Hd0kXI56uotic1407tb4ltkCSMzqqozFpvobH8=";
  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd nali \
      --bash <($out/bin/nali completion bash) \
      --fish <($out/bin/nali completion fish) \
      --zsh <($out/bin/nali completion zsh)
  '';

  meta = with lib; {
    description = "An offline tool for querying IP geographic information and CDN provider";
    homepage = "https://github.com/zu1k/nali";
    license = licenses.mit;
    maintainers = with maintainers; [ diffumist xyenon ];
  };
}
