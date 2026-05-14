{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "comigo";
  version = "1.2.30";

  src = fetchFromGitHub {
    owner = "yumenaka";
    repo = "comigo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JS+KgXmYEx3V5FnFqcDwFonxRHg5f5n8uH4MtpT0e3g=";
  };

  vendorHash = "sha256-OUmqbev7Eq79co8RdmwOF6fqcOWwwm6Kx4fbvd2DJU4=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
  ];

  __structuredAttrs = true;

  meta = {
    description = "Simple and Efficient Comic Reader";
    homepage = "https://github.com/yumenaka/comigo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "comigo";
  };
})
