{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "css-checker";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "ruilisi";
    repo = "css-checker";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lD2uF8zhJG8pVepqxyKKj4GZNB883uDV/9dCMFYJbRs=";
  };

  vendorHash = "sha256-4ZCma8Q7FXAWdA1m2M1ltm360Fu65JhELyfIbJBP14M=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Command-line tool for identifying similar or duplicated CSS code";
    homepage = "https://github.com/ruilisi/css-checker";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ arikgrahl ];
    mainProgram = "css-checker";
  };
})
