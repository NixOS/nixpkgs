{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "portmaster";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "safing";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Uw4sc6zxEkQGznjrtKnBM4Xq6segj1cjHRwAHkRLYcs=";
  };

  vendorHash = "sha256-RQSArURloe8mVud5t1lgzYX8HePEloq1lKxZxQrl4C0=";

  # integration tests require root access
  doCheck = false;

  meta = with lib; {
    description = "A free and open-source application firewall that does the heavy lifting for you";
    homepage = "https://safing.io";
    license = licenses.agpl3;
    maintainers = with maintainers; [ urandom ];
  };
}
