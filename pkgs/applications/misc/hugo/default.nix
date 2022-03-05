{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "hugo";
  version = "0.92.2";

  src = fetchFromGitHub {
    owner = "gohugoio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kwqN/9H/ZI2eL09K/9bOMBWW9bow8LtKpbfxyfxIucA=";
  };

  vendorSha256 = "sha256-7dJUl0IxsLj0ds2jqtChNCQEBiK9PahG159IhyFxwdM=";

  doCheck = false;

  proxyVendor = true;

  tags = [ "extended" ];

  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    $out/bin/hugo gen man
    installManPage man/*
    installShellCompletion --cmd hugo \
      --bash <($out/bin/hugo gen autocomplete --type=bash) \
      --fish <($out/bin/hugo gen autocomplete --type=fish) \
      --zsh <($out/bin/hugo gen autocomplete --type=zsh)
  '';

  meta = with lib; {
    description = "A fast and modern static website engine";
    homepage = "https://gohugo.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ schneefux Br1ght0ne Frostman ];
  };
}
