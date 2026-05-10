{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "minica";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "jsha";
    repo = "minica";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-YUeP3xBoZzonJYfEAOWZYCTFwOxFWySW7ezvpMLNZ1I=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Simple tool for generating self signed certificates";
    mainProgram = "minica";
    longDescription = ''
      Minica is a simple CA intended for use in situations where the CA operator
      also operates each host where a certificate will be used. It automatically
      generates both a key and a certificate when asked to produce a
      certificate.
    '';
    homepage = "https://github.com/jsha/minica/";
    changelog = "https://github.com/jsha/minica/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ m1cr0man ];
  };
})
