{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ec2-metadata-mock";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "amazon-ec2-metadata-mock";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-8X6LBGo496fG0Chhvg3jAaUF6mp8psCzHd+Es75z27Y=";
  };

  vendorHash = "sha256-jRJX4hvfRuhR5TlZe7LsXaOlUCwmQGem2QKlX3vuk8c=";

  postInstall = ''
    mv $out/bin/{cmd,ec2-metadata-mock}
  '';

  meta = {
    description = "Amazon EC2 Metadata Mock";
    mainProgram = "ec2-metadata-mock";
    homepage = "https://github.com/aws/amazon-ec2-metadata-mock";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ymatsiuk ];
  };
})
