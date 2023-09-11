{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, buildPackages
, testers
, hugo
}:

buildGoModule rec {
  pname = "hugo";
  version = "0.118.2";

  src = fetchFromGitHub {
    owner = "gohugoio";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-kEcLcNdhUjCTBfBVMYh+/5xxiCrGWeW8my//FcyXWtA=";
  };

  vendorHash = "sha256-FXL6MtZ3kQOlzFuAWdnRoj/0b+XIWy2avuXbU5gz7Bc=";

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

  passthru.tests.version = testers.testVersion {
    package = hugo;
    command = "hugo version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "A fast and modern static website engine";
    homepage = "https://gohugo.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ schneefux Br1ght0ne Frostman ];
  };
}
