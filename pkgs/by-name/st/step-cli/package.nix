{
  lib,
  buildGoModule,
  fetchFromGitHub,
}: let
  version = "0.26.2";
in
  buildGoModule {
    pname = "step-cli";
    inherit version;

    src = fetchFromGitHub {
      owner = "smallstep";
      repo = "cli";
      rev = "refs/tags/v${version}";
      hash = "sha256-CrV6kWgq2ldeOh5G0SgO8+q0HC1l8RuTELT3YXLxClU=";
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

    vendorHash = "sha256-pqwrjreysMLfVmzPE7Tj/hLdM1HO13UfmbMXvNgLd5Y=";

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
