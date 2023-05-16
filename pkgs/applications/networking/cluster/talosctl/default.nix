{ lib, stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "talosctl";
<<<<<<< HEAD
  version = "1.5.1";
=======
  version = "1.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "siderolabs";
    repo = "talos";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-HYIk1oZbtcnHLap+4AMwoQN0k44zjiiwDzGcNW+9qqM=";
  };

  vendorHash = "sha256-Aefwa8zdKWV9TE9rwNA4pzKZekTurkD0pTDm3QfKdUQ=";
=======
    hash = "sha256-ZnVqpJ62X6JlL/yAjpdh8e3U6Lvs/GncCkKU42GRI/Q=";
  };

  vendorHash = "sha256-1YHYDC22yvtADOIuYxzonV7yaLsQOFELwEEXvu77JdE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-s" "-w" ];

  GOWORK = "off";

  subPackages = [ "cmd/talosctl" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd talosctl \
      --bash <($out/bin/talosctl completion bash) \
      --fish <($out/bin/talosctl completion fish) \
      --zsh <($out/bin/talosctl completion zsh)
  '';

  doCheck = false; # no tests

  meta = with lib; {
    description = "A CLI for out-of-band management of Kubernetes nodes created by Talos";
    homepage = "https://www.talos.dev/";
    license = licenses.mpl20;
    maintainers = with maintainers; [ flokli ];
  };
}
