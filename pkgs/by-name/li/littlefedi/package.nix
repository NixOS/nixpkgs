{
  lib,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "littlefedi";
  version = "26.10.01";

  src = fetchTarball {
    url = "https://littlefedi.org/downloads/littlefedi-${finalAttrs.version}-source.tar.gz";
    sha256 = "0glphncxiv2dmfzywrb10l3anz8gkq747xnapxh3rhq8p5x016aw";
  };

  vendorHash = "sha256-v/59oqxSMfHhnPXL7sJfDvTa+iSzW3PDvEVpDDfFqho=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "A lightweight ActivityPub server";
    mainProgram = "littlefedi";
    homepage = "https://littlefedi.org";
    license = with lib.licenses; [
      mit
    ];
    maintainers = with lib.maintainers; [ raylas ];
  };
})
