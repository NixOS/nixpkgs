{ stdenv, lib, buildGoModule, fetchFromGitHub, installShellFiles, buildPackages }:

buildGoModule rec {
  pname = "hugo";
  version = "0.111.3";

  src = fetchFromGitHub {
    owner = "gohugoio";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-PgconAixlSgRHqmfRdOtcpVJyThZIKAB9Pm4AUvYVGQ=";
  };

  vendorHash = "sha256-2a6+s0xLlj3VzXp9zbZgIi7WJShbUQH48tUG9Slm770=";

  doCheck = false;

  proxyVendor = true;

  tags = [ "extended" ];

  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-s" "-w" "-X github.com/gohugoio/hugo/common/hugo.vendorInfo=nixpkgs" ];

  postInstall = let emulator = stdenv.hostPlatform.emulator buildPackages; in ''
    ${emulator} $out/bin/hugo gen man
    installManPage man/*
    installShellCompletion --cmd hugo \
      --bash <(${emulator} $out/bin/hugo completion bash) \
      --fish <(${emulator} $out/bin/hugo completion fish) \
      --zsh  <(${emulator} $out/bin/hugo completion zsh)
  '';

  meta = with lib; {
    description = "A fast and modern static website engine";
    homepage = "https://gohugo.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ schneefux Br1ght0ne Frostman ];
  };
}
