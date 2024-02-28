# I just copied this from Hugo's package becuase I don't know what I'm doing
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
  pname = "dotcopy";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "firesquid6";
    repo = pname;
    rev = "refs/tags/v${version}";
  };

  tags = [ "extended" ];

  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];

  # idk what this does
  # ldflags = [ "-s" "-w" "-X github.com/gohugoio/hugo/common/hugo.vendorInfo=nixpkgs" ];

  # yeah I should figure out manuals and stuff
  # postInstall = let emulator = stdenv.hostPlatform.emulator buildPackages; in ''
  #   ${emulator} $out/bin/hugo gen man
  #   installManPage man/*
  #   installShellCompletion --cmd hugo \
  #     --bash <(${emulator} $out/bin/hugo completion bash) \
  #     --fish <(${emulator} $out/bin/hugo completion fish) \
  #     --zsh  <(${emulator} $out/bin/hugo completion zsh)
  # '';

  # don't thing I need this either
  # passthru.tests.version = testers.testVersion {
  #   package = ;
  #   command = "hugo version";
  #   version = "v${version}";
  # };

  meta = with lib; {
    description = "A linux dotfile manager";
    homepage = "https://dotcopy.firesquid.co";
    license = licenses.gpl3;
    longDescription = ''
      Dotcopy is a linux dotfile manager that allows you to "compile" your dotfiles to use the same template for multiple machines.
    '';
    maintainers = with maintainers; [ firesquid6 ];
  };
}
