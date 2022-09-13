{ buildGoModule, fetchFromGitHub, installShellFiles, lib }:

let
  humioCtlVersion = "0.30.0";
  sha256 = "sha256-BwpnqaUZvttGRtsZT2xcyXfMJZ7EIsKenTPF669ktQM=";
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
