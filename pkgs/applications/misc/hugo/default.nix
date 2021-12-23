{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "hugo";
  version = "0.91.1";

  src = fetchFromGitHub {
    owner = "gohugoio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TPJGRXiZQ7yEttGFpVdiFcyUL5emfjfuoq3k+dQmKCg=";
  };

  vendorSha256 = "sha256-ViWbqWjlHd8yosxe+CF1GJ9oK+plOn9s7ruhgsX/v58=";

  doCheck = false;

  runVend = true;

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
