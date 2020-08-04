{ buildGoModule, fetchFromGitHub, installShellFiles, stdenv }:

let
  humioCtlVersion = "0.26.0";
  sha256 = "1j33hmvhkb546dbi2qd5hmpcv715yg9rnpxicc1mayr9f1i2aj2i";
  vendorSha256 = "1l2wa4w43srfrkb4qrgiyzdb6bnaqvp9g3fnrln6bhrcw6jsgj4z";
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
