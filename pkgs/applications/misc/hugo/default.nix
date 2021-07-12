{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "hugo";
  version = "0.85.0";

  src = fetchFromGitHub {
    owner = "gohugoio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-IW41e4imaXKcXJKa7dAB60ulvRrk3qvF1//Lo55TLVI=";
  };

  vendorSha256 = "sha256-ZIGw349m6k8qqrzUN/oYV/HrgBvfOo/ovjo1SUDRmyk=";

  doCheck = false;

  runVend = true;

  buildFlags = [ "-tags" "extended" ];

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
