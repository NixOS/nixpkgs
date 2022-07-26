{ stdenv, lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "hugo";
  version = "0.101.0";

  src = fetchFromGitHub {
    owner = "gohugoio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Fodcefp8xdSV2tt6ZYaKdcLqVe2upEngQr6M+wV5wnw=";
  };

  vendorSha256 = "sha256-tZQIKxY96G6ReegqjapJ2rLd7n92+axJ7F8UglF61eM=";

  doCheck = false;

  proxyVendor = true;

  tags = [ "extended" ];

  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];

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
