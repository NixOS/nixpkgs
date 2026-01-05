{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "fsql";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "kshvmdn";
    repo = "fsql";
    rev = "v${version}";
    sha256 = "sha256-U6TPszqsZvoz+9GIB0wNYMRJqIDLOp/BZO3/k8FC0Gs=";
  };

  vendorHash = "sha256-+laTnx6Xkrv3QQel5opqYQSuFmo54UMI2A653xbBWzQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Search through your filesystem with SQL-esque queries";
    homepage = "https://github.com/kshvmdn/fsql";
    license = licenses.mit;
    maintainers = with maintainers; [ pSub ];
    mainProgram = "fsql";
  };
}
