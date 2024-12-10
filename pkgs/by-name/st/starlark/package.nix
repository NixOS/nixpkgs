{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "starlark";
  version = "0-unstable-2024-05-21";

  src = fetchFromGitHub {
    owner = "google";
    repo = "starlark-go";
    rev = "046347dcd1044f5e568fcf64884b0344f27910c0";
    hash = "sha256-qpJPCcMxrsspiN5FeQDZRaNchYPawMNJHtKK8fmrRug=";
  };

  vendorHash = "sha256-8drlCBy+KROyqXzm/c+HBe/bMVOyvwRoLHxOApJhMfo=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    homepage = "https://github.com/google/starlark-go";
    description = "Interpreter for Starlark, implemented in Go";
    license = licenses.bsd3;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "starlark";
  };
}
