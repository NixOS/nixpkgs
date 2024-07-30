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
  version = "0.129.0";

  src = fetchFromGitHub {
    owner = "gohugoio";
    repo = "hugo";
    rev = "refs/tags/v${version}";
    hash = "sha256-F76iT6rBloVNCc16VjQa7aoZP5hvcfGzqoVhXG43TGo=";
  };

  vendorHash = "sha256-3ILFdQ3B/q5SX0JBlatN41swl0ijMne0AWnGbmcXMDc=";

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

  meta = {
    changelog = "https://github.com/gohugoio/hugo/releases/tag/v${version}";
    description = "Fast and modern static website engine";
    homepage = "https://gohugo.io";
    license = lib.licenses.asl20;
    mainProgram = "hugo";
    maintainers = with lib.maintainers; [ schneefux Br1ght0ne Frostman ];
  };
}
