{ buildGoModule, fetchFromGitHub, installShellFiles, stdenv }:

let
  humioCtlVersion = "0.25.0";
  sha256 = "1x8354m410nf9g167v0i1c77s5w2by7smdlyjwl89ixgdjw04ay3";
  vendorSha256 = "14bysjgvahr56hvd8walym11hh721i1q2g503n8m68wdzrrym4qy";
in buildGoModule {
    name = "humioctl-${humioCtlVersion}";
    pname = "humioctl";
    version = humioCtlVersion;

    vendorSha256 = vendorSha256;

    src = fetchFromGitHub {
      owner = "humio";
      repo = "cli";
      rev = "v${humioCtlVersion}";
      sha256 = sha256;
    };

    buildFlagsArray = "-ldflags=-X main.version=${humioCtlVersion}";

    nativeBuildInputs = [ installShellFiles ];

    postInstall = ''
      mv $out/bin/cli $out/bin/humioctl
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
