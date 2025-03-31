{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "bump";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "mroth";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-a+vmpmWb/jICNdErkvCQKNIdaKtSrIJZ3BApLvKG/hg=";
  };

  vendorHash = "sha256-VHVChqQXmCcw2ymTJbQLDtzBycTeXkuHPz52vuKen0w=";

  doCheck = false;

  ldflags = [
    "-X main.buildVersion=${version}"
    "-X main.buildCommit=${version}"
    "-X main.buildDate=1970-01-01"
  ];

  meta = with lib; {
    license = licenses.mit;
    homepage = "https://github.com/mroth/bump";
    description = "CLI tool to draft a GitHub Release for the next semantic version";
    mainProgram = "bump";
    maintainers = with maintainers; [ doronbehar ];
  };
}
