{ buildGoModule, fetchFromGitHub, installShellFiles, stdenv }:

let
  humioCtlVersion = "0.28.1";
  sha256 = "0vy07nzafqhc14i179sfrzb795yh4pcyjj3py9fwq0nwnmxndby4";
  vendorSha256 = "0anvah2rpqvxgmdrdj73k3vbf8073nmsl3aykgvb1nraf3gz3bpk";
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

    buildFlagsArray = "-ldflags=-X main.version=${humioCtlVersion}";

    nativeBuildInputs = [ installShellFiles ];

    postInstall = ''
      $out/bin/humioctl completion bash > humioctl.bash
      $out/bin/humioctl completion zsh > humioctl.zsh
      installShellCompletion humioctl.{bash,zsh}
    '';

    meta = with stdenv.lib; {
      homepage = "https://github.com/humio/cli";
      description = "A CLI for managing and sending data to Humio";
      license = licenses.asl20;
      maintainers = with maintainers; [ lucperkins ];
    };
  }
