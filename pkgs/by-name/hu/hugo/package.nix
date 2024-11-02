{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  buildPackages,
  testers,
  nix-update-script,
  hugo,
}:

buildGoModule rec {
  pname = "hugo";
  version = "0.136.4";

  src = fetchFromGitHub {
    owner = "gohugoio";
    repo = "hugo";
    rev = "refs/tags/v${version}";
    hash = "sha256-wCv0lZqvJNOwL/naFuGb6k0Xyk58NpgH1mkhoNnkSno=";
  };

  vendorHash = "sha256-KqDsa7MlSONyn7AYOepQ95q1CEM83AhWk23iYSQ4twU=";

  doCheck = false;

  proxyVendor = true;

  tags = [ "extended" ];

  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/gohugoio/hugo/common/hugo.vendorInfo=nixpkgs"
  ];

  postInstall =
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
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

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/gohugoio/hugo/releases/tag/v${version}";
    description = "Fast and modern static website engine";
    homepage = "https://gohugo.io";
    license = lib.licenses.asl20;
    mainProgram = "hugo";
    maintainers = with lib.maintainers; [
      schneefux
      Br1ght0ne
      Frostman
    ];
  };
}
