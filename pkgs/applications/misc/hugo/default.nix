{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "hugo";
  version = "0.102.2";

  src = fetchFromGitHub {
    owner = "gohugoio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mAkdx42JaYSSpNLssBNkX45V3VniVKVbPt2SQ/QaXmY=";
  };

  vendorSha256 = "sha256-oWOu8vmxe0a/nIgkjpx7XrB49rjcuqnnpuOMtI9bLfY=";

  doCheck = false;

  proxyVendor = true;

  tags = [ "extended" ];

  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-s" "-w" "-X github.com/gohugoio/hugo/common/hugo.vendorInfo=nixpkgs" ];

  postInstall = ''
    $out/bin/hugo gen man
    installManPage man/*
    installShellCompletion --cmd hugo \
      --bash <($out/bin/hugo completion bash) \
      --fish <($out/bin/hugo completion fish) \
      --zsh <($out/bin/hugo completion zsh)
  '';

  meta = with lib; {
    description = "A fast and modern static website engine";
    homepage = "https://gohugo.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ schneefux Br1ght0ne Frostman ];
  };
}
