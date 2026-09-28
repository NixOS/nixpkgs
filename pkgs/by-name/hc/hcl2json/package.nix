{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "hcl2json";
  version = "0.6.9";

  src = fetchFromGitHub {
    owner = "tmccombs";
    repo = "hcl2json";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-CiF5xbRov28xWWygSI9JIG1t/irUyuUxM2vzGnbazGg=";
  };

  vendorHash = "sha256-bQFm3BmYxvSe5NRbh1+tG6wWP5C3DSr3g+E36oqk5oY=";

  subPackages = [ "." ];

  meta = {
    description = "Convert hcl2 to json";
    homepage = "https://github.com/tmccombs/hcl2json";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "hcl2json";
  };
})
