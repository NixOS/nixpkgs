{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "sd-local";
  version = "1.0.57";

  src = fetchFromGitHub {
    owner = "screwdriver-cd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CBEdE15lAMMawTsfc45ptHsC2AbqFP6v4/nnktytwvc=";
  };

  vendorHash = "sha256-rAFfyMlnhDrb+f04S9+hNygXPaoG9mheQMxaJtXxBVw=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "screwdriver.cd local mode";
    mainProgram = "sd-local";
    homepage = "https://github.com/screwdriver-cd/sd-local";
    license = licenses.bsd3;
    maintainers = with maintainers; [ midchildan ];
  };
}
