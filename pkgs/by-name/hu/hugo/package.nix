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
  version = "0.127.0";

  src = fetchFromGitHub {
    owner = "gohugoio";
    repo = "hugo";
    rev = "refs/tags/v${version}";
    hash = "sha256-QAZP119VOPTnVXe2mtzCpB3OW/g73oA/qwR94OzISKo=";
  };

  vendorHash = "sha256-Og7FTCrto1l+Xpfr2zEgg/yXa7dflws0yJ2Xh9f3mbI=";

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
