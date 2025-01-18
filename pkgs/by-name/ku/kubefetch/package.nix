{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "kubefetch";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "jkulzer";
    repo = "kubefetch";
    rev = "${version}";
    hash = "sha256-1NbbQ9f81DbfvpGayhMYdOTOZrDg2hdZi+qUOr2mntY=";
  };

  vendorHash = "sha256-qsncOsCxepySJI+rJnzbIGxSWlxMzqShtzcEoJD2UPw=";

  meta = with lib; {
    description = "A neofetch-like tool to show info about your Kubernetes Cluster.";
    homepage = "https://github.com/jkulzer/kubefetch";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ wrmilling ];
    mainProgram = "kubefetch";
  };
}
