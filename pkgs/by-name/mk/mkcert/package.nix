{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mkcert";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = "mkcert";
    rev = "v${version}";
    sha256 = "sha256-FMAXjRL+kJ/hwGmaWBy8ecON+JCMgRytfpryeLWsSVc=";
  };

  vendorHash = "sha256-DdA7s+N5S1ivwUgZ+M2W/HCp/7neeoqRQL0umn3m6Do=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=v${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/FiloSottile/mkcert";
    description = "Simple tool for making locally-trusted development certificates";
    mainProgram = "mkcert";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
