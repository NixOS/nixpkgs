{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "amazon-ec2-metadata-mock";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "amazon-ec2-metadata-mock";
    rev = "refs/tags/v${version}";
    hash = "sha256-8X6LBGo496fG0Chhvg3jAaUF6mp8psCzHd+Es75z27Y=";
  };

  vendorHash = "sha256-jRJX4hvfRuhR5TlZe7LsXaOlUCwmQGem2QKlX3vuk8c=";

  subPackages = [ "cmd/" ];

  postBuild = ''
    mv "$GOPATH/bin/cmd" "$GOPATH/bin/$mainProgram"
  '';

  mainProgram = "ec2-metadata-mock";
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/${mainProgram}";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "A tool to simulate Amazon EC2 instance metadata";
    homepage = "https://github.com/aws/amazon-ec2-metadata-mock";
    license = lib.licenses.asl20;
    inherit mainProgram;
    maintainers = with lib.maintainers; [ arianvp ];
  };
}
