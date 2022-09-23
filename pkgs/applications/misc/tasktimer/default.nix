{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tasktimer";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-M88JzcK9HwHeWbQ0McbCF1rIEiKnwh08oEoRck4A/Ho=";
  };

  vendorSha256 = "sha256-5OSAa7tGPtGyx0bet82FRoIozhhlFtakbPt6PtCTHd0=";

  postInstall = ''
    mv $out/bin/tasktimer $out/bin/tt
  '';

  meta = with lib; {
    description = "Task Timer (tt) is a dead simple TUI task timer";
    homepage = "https://github.com/caarlos0/tasktimer";
    license = licenses.mit;
    maintainers = with maintainers; [ abbe ];
    mainProgram = "tt";
  };
}
