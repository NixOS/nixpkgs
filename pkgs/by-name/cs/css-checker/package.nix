{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "css-checker";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "ruilisi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-lD2uF8zhJG8pVepqxyKKj4GZNB883uDV/9dCMFYJbRs=";
  };

  vendorHash = "sha256-4ZCma8Q7FXAWdA1m2M1ltm360Fu65JhELyfIbJBP14M=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Command-line tool for identifying similar or duplicated CSS code";
    homepage = "https://github.com/ruilisi/css-checker";
    license = licenses.mit;
    maintainers = with maintainers; [ arikgrahl ];
    mainProgram = "css-checker";
  };
}
