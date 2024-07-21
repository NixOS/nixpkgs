{
  lib,
  buildGoModule,
  fetchFromGitHub,
}: let
  version = "0.27.1";
in
  buildGoModule {
    pname = "step-cli";
    inherit version;

    src = fetchFromGitHub {
      owner = "smallstep";
      repo = "cli";
      rev = "refs/tags/v${version}";
      hash = "sha256-+2++unFtLXQCDTem49DfO1ZjbaDWeBw0C7Z3CSGQkTk=";
    };

    ldflags = [
      "-w"
      "-s"
      "-X=main.Version=${version}"
    ];

    preCheck = ''
      # Tries to connect to smallstep.com
      rm command/certificate/remote_test.go
    '';

    vendorHash = "sha256-1+WLdjShvprt2fqzRYsEWQj/ohn6HqLGTde+3GZq7x0=";

    meta = {
      description = "Zero trust swiss army knife for working with X509, OAuth, JWT, OATH OTP, etc";
      homepage = "https://smallstep.com/cli/";
      changelog = "https://github.com/smallstep/cli/blob/v${version}/CHANGELOG.md";
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [isabelroses];
      platforms = lib.platforms.linux ++ lib.platforms.darwin;
      mainProgram = "step";
    };
  }
