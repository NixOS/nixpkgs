{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "sd-local";
  version = "1.0.56";

  src = fetchFromGitHub {
    owner = "screwdriver-cd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qgfckqF33fXphAsdxd5r6/rebNEURPfazw/AQgB5jiI=";
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
