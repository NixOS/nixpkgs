{ buildGoModule, fetchFromGitHub, installShellFiles, lib }:

<<<<<<< HEAD
buildGoModule rec {
  pname = "humioctl";
  version = "0.31.1";

  src = fetchFromGitHub {
    owner = "humio";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-L5Ttos0TL8m62Y69riwnGmB1cOVF6XIH7jMVU8NuFKI=";
  };

  vendorHash = "sha256-GTPEHw3QsID9K6DcYNZRyDJzTqfDV9lHP2Trvd2aC8Y=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd humioctl \
      --bash <($out/bin/humioctl completion bash) \
      --zsh <($out/bin/humioctl completion zsh)
  '';

  meta = with lib; {
    homepage = "https://github.com/humio/cli";
    description = "A CLI for managing and sending data to Humio";
    license = licenses.asl20;
    maintainers = with maintainers; [ lucperkins ];
  };
}
=======
let
  humioCtlVersion = "0.30.2";
  sha256 = "sha256-FqBS6PoEKMqK590f58re4ycYmrJScyij74Ngj+PLzLs=";
  vendorSha256 = "sha256-70QxW2nn6PS6HZWllmQ8O39fbUcbe4c/nKAygLnD4n0=";
in buildGoModule {
    name = "humioctl-${humioCtlVersion}";
    pname = "humioctl";
    version = humioCtlVersion;

    vendorSha256 = vendorSha256;

    doCheck = false;

    src = fetchFromGitHub {
      owner = "humio";
      repo = "cli";
      rev = "v${humioCtlVersion}";
      sha256 = sha256;
    };

    ldflags = [ "-X main.version=${humioCtlVersion}" ];

    nativeBuildInputs = [ installShellFiles ];

    postInstall = ''
      $out/bin/humioctl completion bash > humioctl.bash
      $out/bin/humioctl completion zsh > humioctl.zsh
      installShellCompletion humioctl.{bash,zsh}
    '';

    meta = with lib; {
      homepage = "https://github.com/humio/cli";
      description = "A CLI for managing and sending data to Humio";
      license = licenses.asl20;
      maintainers = with maintainers; [ lucperkins ];
    };
  }
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
