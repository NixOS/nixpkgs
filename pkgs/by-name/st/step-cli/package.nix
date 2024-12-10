{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "0.26.1";
in
buildGoModule {
  pname = "step-cli";
  inherit version;

  src = fetchFromGitHub {
    owner = "smallstep";
    repo = "cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-BVxdgyQsfCwHw/zjP3AKNib3sRWoBpMlZ7vh71nso94=";
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

  vendorHash = "sha256-Z6wrWkyAGi01gH7+v2+VkyqRNqDwLFVwXm/1FIMzURg=";

  meta = {
    description = "A zero trust swiss army knife for working with X509, OAuth, JWT, OATH OTP, etc";
    homepage = "https://smallstep.com/cli/";
    changelog = "https://github.com/smallstep/cli/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ isabelroses ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "step";
  };
}
