{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "hydroxide";
  version = "0.2.30";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "hydroxide";
    rev = "v${version}";
    sha256 = "sha256-PjT8kIS2k4e9Xuw6uCXiCtg5Rawvcmslzz9Qa4Wnroo=";
  };

  vendorHash = "sha256-NKWUpyS5IHBTPzjfTkov/ypoGQW6inX32Y7lpdIDOUc=";

  doCheck = false;

  subPackages = [ "cmd/hydroxide" ];

  meta = with lib; {
    description = "Third-party, open-source ProtonMail bridge";
    homepage = "https://github.com/emersion/hydroxide";
    license = licenses.mit;
    mainProgram = "hydroxide";
  };
}
