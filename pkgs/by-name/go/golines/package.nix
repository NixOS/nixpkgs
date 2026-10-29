{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "golines";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "golangci";
    repo = "golines";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-NveivuTEy+lvgsu32YuBE9lHhV4aTcI04BkMlZiIEGw=";
  };

  vendorHash = "sha256-bn4C1d7EdAfBJZkWJByOQns+ng7F15eUs8BgYExB/g8=";

  subPackages = [
    "."
  ];

  meta = {
    description = "Golang formatter that fixes long lines";
    homepage = "https://github.com/golangci/golines";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ meain ];
    mainProgram = "golines";
  };
})
