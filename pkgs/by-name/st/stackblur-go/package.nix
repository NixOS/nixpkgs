{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "stackblur-go";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "esimov";
    repo = "stackblur-go";
    rev = "v${finalAttrs.version}";
    hash = "sha256-PGYMqpk98bGJSZbyYBcZBqaPS3syfYSOymq33C+DxNM=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Fast, almost Gaussian Blur implementation in Go";
    homepage = "https://github.com/esimov/stackblur-go";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sodiboo ];
    mainProgram = "stackblur";
  };
})
